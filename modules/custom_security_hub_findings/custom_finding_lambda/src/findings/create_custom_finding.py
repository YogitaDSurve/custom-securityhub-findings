import os
import uuid
from datetime import datetime, timezone


class CustomFinding:
    def __init__(self):
        self.id = str(uuid.uuid4())
        self.time = datetime.now(tz=timezone.utc).isoformat()
        self.account_id = os.environ['account_num']
        self.aws_region = os.environ['region']
