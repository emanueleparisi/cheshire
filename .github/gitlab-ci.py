#!/usr/bin/env python3
#
# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Paul Scheffler <paulsc@iis.ee.ethz.ch>

import os
import sys
import time
import requests


def main():
    # How often to retry if no pipeline exists and period (default: 2 min timeout)
    retry_cnt = os.getenv('RETRY_CNT', default=12)
    retry_period = os.getenv('RETRY_PERIOD', default=10)
    # How often to poll and period (default: 2 hour timeout)
    poll_cnt = os.getenv('POLL_CNT', 720)
    poll_period = os.getenv('POLL_PERIOD', 10)
    # Mandatory parameters
    token = os.environ['TOKEN']
    sha = os.environ['SHA']
    pipelines = os.environ['PIPELINES']

    # Wait for pipeline to spawn
    for i in range(1, retry_cnt+1):
        response = requests.get(pipelines, headers={'PRIVATE-TOKEN': token}).json()
        try:
            next(p for p in response if p['sha'] == sha)
            break
        except StopIteration:
            print(f'[{i*retry_period}s] No pipeline yet for SHA {sha}')
            time.sleep(retry_period)
    else:
        print(f'[{retry_cnt*retry_period}s] Pipeline spawn timeout')
        return 2

    # Wait for pipeline to complete
    for i in range(1, poll_cnt+1):
        response = requests.get(pipelines, headers={'PRIVATE-TOKEN': token}).json()
        pipeline = next(p for p in response if p['sha'] == sha)
        if pipeline['status'] == 'success':
            print(f'[{i*poll_period}s] Pipeline success! See {pipeline["web_url"]}')
            return 0
        elif pipeline['status'] == 'failed':
            print(f'[{i*poll_period}s] Pipeline failure! See {pipeline["web_url"]}')
            return 1
        print(f'[{i*poll_period}s] Pipeline status: {pipeline["status"]}')
        time.sleep(poll_period)
    else:
        print(f'[{poll_cnt*poll_period}s] Pipeline completion timeout! See {pipeline["web_url"]}')
        return 3


if __name__ == '__main__':
    sys.exit(main())
