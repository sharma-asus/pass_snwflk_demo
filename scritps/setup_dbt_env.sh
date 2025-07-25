#!/bin/bash

###########exit immediately if a command exits with a non-zero status
set -e

###########fail the script if any command in a pipeline fails
set -o pipefail

echo "Starting DBT Setup script"

###############################################
###############################################
if ! command -v python &> /dev/null; then
    echo "Python is not installed. Please install Python and try again."
    exit 1
else
    echo "Python is installed. $(python --version)"
    # Create virrtual environment for dbt
    python -m venv dbt-env
fi

################################################
################################################
if ! command -v pip &> /dev/null; then
    echo "pip is not installed. Please install pip and try again."
    exit 1
fi

###########Check if the virtual environment was created successfully
if [ ! -d "dbt-env" ]; then
    echo "Failed to create virtual environment."
    exit 1
else
    echo "Virtual environment 'dbt-env' created successfully."

fi

###########Check if the 'bin' directory exists in the virtual environment
if [ ! -d "dbt-env/bin" ]; then
    echo "Virtual environment 'dbt-env' does not contain a 'bin' directory."
    exit 1
else
    source dbt-env/bin/activate
    pip install --upgrade pip
    pip install dbt-snowflake
fi

###########Check if dbt is installed successfully
if ! command -v dbt &> /dev/null; then
    echo "DBT installation failed. Please check the installation logs."
    exit 1
else
    echo "DBT installed successfully. Version: $(dbt --version)"
fi

##################################################
##################################################

# Create ~/.dbt directory and add profiles.yml
mkdir -p ~/.dbt
cat <<EOF > ~/.dbt/profiles.yml
pass_snwflk_demo:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: ${SNOWFLAKE_ACCOUNT}
      user: ${SNOWFLAKE_USER}
      role: ${SNOWFLAKE_DATABASE}
      database: ${SNOWFLAKE_DATABASE}
      warehouse: ${SNOWFLAKE_WAREHOUSE}
      schema: ${SNOWFLAKE_SCHEMA}
      private_key: |
$(echo "${SNOWFLAKE_PRIVATE_KEY_RAW}" | sed 's/^/        /')
        threads: 1
        client_session_keep_alive: FALSE   
EOF

# Check if the profiles.yml file was created successfully
if [ ! -f ~/.dbt/profiles.yml ]; then
    echo "Failed to create ~/.dbt/profiles.yml. Please check the DBT_PROFILE_YML variable."
    exit 1
else
    echo "DBT profiles.yml created successfully at ~/.dbt/profiles.yml"
fi


