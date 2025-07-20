import json
import boto3

def lambda_handler(event, context):
    print("Received event:", json.dumps(event))
    data = json.loads(event['Records'][0]['body'])['content'][0]['text']
    event_id = event['Records'][0]['messageId']
    data = json.loads(data)

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('birth_certificates')

    applicant_details = data.get('applicantDetails', {})
    mailing_address = data.get('mailingAddress', {})
    relation_to_applicant = data.get('relationToApplicant', [])
    birth_certificate_details = data.get('BirthCertificateDetails', {})
    fees = data.get('fees', {})

    # Parse the SQS message body
    message_body = json.loads(event['Records'][0]['body'])
    print("Message body:", json.dumps(message_body))

    # Get the message ID for the DynamoDB primary key
    event_id = event['Records'][0]['messageId']

    # Extract the text content from the Claude response
    if 'content' in message_body and len(message_body['content']) > 0:
        text_content = message_body['content'][0]['text']
        print("Text content:", text_content)

        # Try to parse the text as JSON
        try:
            data = json.loads(text_content)
            print("Parsed data:", json.dumps(data))
        except json.JSONDecodeError as e:
            print(f"Failed to parse text as JSON: {str(e)}")
            print("Raw text content:", text_content)
            # If the text isn't valid JSON, try to extract JSON from it
            # Look for opening and closing braces
            start_idx = text_content.find('{')
            end_idx = text_content.rfind('}')

            if start_idx >= 0 and end_idx > start_idx:
                json_str = text_content[start_idx:end_idx+1]
                try:
                    data = json.loads(json_str)
                    print("Extracted JSON data:", json.dumps(data))
                except json.JSONDecodeError:
                    print("Failed to extract valid JSON from text")
                    return {'statusCode': 422, 'body': 'Failed to extract valid JSON from text'}
            else:
                print("No JSON structure found in text")
                return {'statusCode': 422, 'body': 'No JSON structure found in text'}
    else:
        print("No content field found in message body")
        return {'statusCode': 422, 'body': 'No content field found in message body'}


    try:
        table.put_item(Item={
            'Id': event_id,
            'applicantName': applicant_details.get('applicantName', ''),
            'dayPhoneNumber': applicant_details.get('dayPhoneNumber', ''),
            'address': applicant_details.get('address', ''),
            'city': applicant_details.get('city', ''),
            'state': applicant_details.get('state', ''),
            'zipCode': applicant_details.get('zipCode', ''),
            'email': applicant_details.get('email', ''),
            'mailingAddressApplicantName': mailing_address.get('mailingAddressApplicantName', ''),
            'mailingAddress': mailing_address.get('mailingAddress', ''),
            'mailingAddressCity': mailing_address.get('mailingAddressCity', ''),
            'mailingAddressState': mailing_address.get('mailingAddressState', ''),
            'mailingAddressZipCode': mailing_address.get('mailingAddressZipCode', ''),
            'relationToApplicant': ', '.join(relation_to_applicant),
            'purposeOfRequest': data.get('purposeOfRequest', ''),
            'nameOnBirthCertificate': birth_certificate_details.get('nameOnBirthCertificate', ''),
            'dateOfBirth': birth_certificate_details.get('dateOfBirth', ''),
            'sex': birth_certificate_details.get('sex', ''),
            'cityOfBirth': birth_certificate_details.get('cityOfBirth', ''),
            'countyOfBirth': birth_certificate_details.get('countyOfBirth', ''),
            'mothersMaidenName': birth_certificate_details.get('mothersMaidenName', ''),
            'fathersName': birth_certificate_details.get('fathersName', ''),
            'mothersPlaceOfBirth': birth_certificate_details.get('mothersPlaceOfBirth', ''),
            'fathersPlaceOfBirth': birth_certificate_details.get('fathersPlaceOfBirth', ''),
            'parentsMarriedAtBirth': birth_certificate_details.get('parentsMarriedAtBirth', ''),
            'numberOfChildrenBornInSCToMother': birth_certificate_details.get('numberOfChildrenBornInSCToMother', ''),
            'diffNameAtBirth': birth_certificate_details.get('diffNameAtBirth', ''),
            'searchFee': fees.get('searchFee', ''),
            'eachAdditionalCopy': fees.get('eachAdditionalCopy', ''),
            'expediteFee': fees.get('expediteFee', ''),
            'totalFees': fees.get('totalFees', '')
        })
    except Exception as e:
        print(f"Error: {str(e)}")
        return {'statusCode': 500, 'body': json.dumps(f'Error: {str(e)}')}

    return {'statusCode': 200, 'body': json.dumps('Data inserted/updated in DynamoDB successfully!')}
