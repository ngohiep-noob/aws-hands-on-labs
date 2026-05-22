import os
from datetime import datetime, timezone
from urllib.parse import unquote_plus

import boto3


s3_client = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")


def _watched_prefix() -> str:
    return os.environ.get("OBJECT_PREFIX", "")


def _to_iso8601(value):
    if value is None:
        return None
    if isinstance(value, str):
        return value
    if value.tzinfo is None:
        value = value.replace(tzinfo=timezone.utc)
    return value.astimezone(timezone.utc).isoformat()


def _build_item(bucket_name, object_key, version_id, event_record, head_object_response):
    metadata = head_object_response.get("Metadata", {})

    return {
        "object_key": object_key,
        "version_id": version_id,
        "bucket_name": bucket_name,
        "etag": head_object_response.get("ETag", "").strip('"'),
        "content_type": head_object_response.get("ContentType", "application/octet-stream"),
        "content_length": int(head_object_response.get("ContentLength", 0)),
        "storage_class": head_object_response.get("StorageClass", "STANDARD"),
        "last_modified": _to_iso8601(head_object_response.get("LastModified")),
        "indexed_at": datetime.now(timezone.utc).isoformat(),
        "event_name": event_record.get("eventName"),
        "event_time": _to_iso8601(event_record.get("eventTime")),
        "sequencer": event_record.get("s3", {}).get("object", {}).get("sequencer"),
        "user_metadata": metadata,
    }


def lambda_handler(event, context):
    table_name = os.environ["TABLE_NAME"]
    watched_prefix = _watched_prefix()
    table = dynamodb.Table(table_name)

    indexed_records = []

    for record in event.get("Records", []):
        bucket_name = record["s3"]["bucket"]["name"]
        object_key = unquote_plus(record["s3"]["object"]["key"])
        version_id = record["s3"]["object"].get("versionId", "null")

        if watched_prefix and not object_key.startswith(watched_prefix):
            continue

        head_object_response = s3_client.head_object(
            Bucket=bucket_name,
            Key=object_key,
            VersionId=version_id,
        )

        item = _build_item(bucket_name, object_key, version_id, record, head_object_response)
        table.put_item(Item=item)
        indexed_records.append({"object_key": object_key, "version_id": version_id})

    return {
        "indexed_records": indexed_records,
        "watch_prefix": watched_prefix,
    }