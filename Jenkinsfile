pipeline {
    agent any

    stages {
        stage('Git pull + submodule') {
            steps {
                sh '''
                git pull
                git submodule update --init --checkout
                cd dscripts && git checkout master && git pull && cd ..
                cd install/opt/jenkins_webhook && git checkout master && git pull && cd ..
                '''
            }
        }
        stage('docker cleanup') {
            steps {
                sh './dscripts/manage.sh rm 2>/dev/null || true'
                sh './dscripts/manage.sh rmvol 2>/dev/null || true'
                sh 'sudo docker ps --all'
            }
        }
        stage('Build') {
            steps {
                sh '''
                echo 'Building ..'
                rm conf.sh 2> /dev/null || true
                ln -s conf.sh.default conf.sh
                ./dscripts/build.sh
                '''
            }
        }
        stage('Test with default user') {
            steps {
                sh '''
                echo 'Configure & start slapd ..'
                randomuid=9999999
                ./dscripts/run.sh -Ip /tests/init_sample_config_phoAt.sh
                ./dscripts/run.sh -p  # start slapd in background
                sleep 2
                echo 'Load initial tree data ..'
                ./dscripts/exec.sh -I /tests/init_dit_data_phoAt.sh
                '''
                sh '''
                echo 'Load test data ..'
                ./dscripts/exec.sh -I /tests/init_sample_data_phoAt.sh
                '''
                sh '''
                echo 'query data ..'
                ./dscripts/exec.sh -I /tests/dump_testuser.sh
                ./dscripts/exec.sh -I /tests/authn_testuser.sh
                ./dscripts/exec.sh -I /tests/test1.sh
                '''
            }
        }
        stage('Test with random user') {
            steps {
                sh '''
                echo 'Configure & start slapd ..'
                randomuid=9999999
                ./dscripts/run.sh -Ip -u $randomuid /tests/init_sample_config_phoAt.sh
                ./dscripts/run.sh -p -u $randomuid  # start slapd in background
                sleep 2
                echo 'Load initial tree data ..'
                ./dscripts/exec.sh -I -u $randomuid /tests/init_dit_data_phoAt.sh
                '''
                sh '''
                echo 'Load test data ..'
                ./dscripts/exec.sh -I -u $randomuid /tests/init_sample_data_phoAt.sh
                '''
                sh '''
                echo 'query data ..'
                ./dscripts/exec.sh -I -u $randomuid /tests/dump_testuser.sh
                ./dscripts/exec.sh -I -u $randomuid /tests/authn_testuser.sh
                ./dscripts/exec.sh -I -u $randomuid /tests/test1.sh
                '''
            }
        }
        stage('Push to Registry') {
            steps {
                sh '''
                ./dscripts/manage.sh push
                '''
            }
        }
    }
    post {
        always {
            echo 'removing docker container and volumes'
            sh '''
            ./dscripts/manage.sh rm 2>&1 || true
            ./dscripts/manage.sh rmvol 2>&1
            '''
        }
    }
}
