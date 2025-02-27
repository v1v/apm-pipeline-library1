#!/usr/bin/env bash
# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

#
# It queries the artifacts-api entry point to fetch the next release
# version for the 8.x line.
#
set -eo pipefail

URL="https://artifacts-api.elastic.co/v1"
NO_KPI_URL_PARAM="x-elastic-no-kpi=true"

curl -s "${URL}/versions?${NO_KPI_URL_PARAM}" \
    | jq -r '.versions[] | select(contains("SNAPSHOT")|not)' \
    | jq -R . | jq -s '. | sort_by(.| split(".") | map(tonumber))' \
    | jq -r '.[]|select(. | startswith("8"))' \
    | tail -n1
