if [ -z "${CORAL_ADMIN_PASSWORD}" ]; then

echo "Must set CORAL_ADMIN_PASSWORD environment variable to value of 'coral_credits_admin_password'
from 'environments/<your-environment>/inventory/group_vars/all/secrets.yml' in your Azimuth config repo"

return 1

fi

if [ -z "${TF_VAR_coral_uri}" ]; then

echo "Must set TF_VAR_coral_uri environment variable to your Coral server's endpoint e.g credits.apps.<azimuth-domain>"

return 1

fi

export TF_VAR_auth_token=$(curl -s -X POST -H "Content-Type: application/json" -d \
    "{
        \"username\": \"admin\", 
        \"password\": \"$CORAL_ADMIN_PASSWORD\"
    }" \
    ${TF_VAR_coral_uri}/api-token-auth/ | jq -r '.token')
