#! /usr/bin/python3

import sys
import requests
from terraform_output import cloudfront_dns

wordpress_url = ''.join(['http://',cloudfront_dns])

def test_check_request_status_code():
    """
    Try to connect to wordpress website domain name and check returned status code
    Test passes if:
        - GET request to website URL is successful
        AND
        - Returned status code is 200 (allowing for redirects)
    If request is not successful a System Exit is raised and the test fails.
    """
    try:
        print("Trying to connect to website...")
        response = requests.get(
                url=wordpress_url,
                allow_redirects=True
        )
        print("Checking HTTP status code...")
        assert response.status_code == 200, "Unexpected status code:" + str(response.status_code)
    except requests.exceptions.RequestException as e:
        raise SystemExit("Request failed:"+ str(e))
