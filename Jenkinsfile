pipeline {
    agent any
        // Jenkins requirements: `sudo docker ...`; python3 in PATH
    stages {
        stage('Prep test env') {
            steps {
                sh 'python3 -c "pass" || $(echo "python3 missing" && exit 3)'
                sh '''
                    if [[ "$(sudo docker ps | grep -s registry)" ]]; then
                        :   # running
                    else
                        $sudo docker run --rm -d -p 5555:5000 --name transient_registry registry:2
                    fi
                '''
            }
        }
        stage('Build with different options') {
            steps {
                sh '''
                    echo 'build.sh (default options)'
                    rm conf.sh 2> /dev/null || true
                    ln -sf conf.sh.default conf.sh
                    ./dscripts/build.sh  -p
                '''
                sh '''
                    echo 'build.sh -b # include label BUILDINFO'
                    ./dscripts/build.sh  -pr
                '''
                sh '''
                    echo 'build.sh -r # remove existing image (default tag)'
                    ./dscripts/build.sh  -pr
                '''
                sh '''
                    echo 'build.sh -c # --no-cache'
                    ./dscripts/build.sh  -pc
                '''
                sh '''
                    echo 'build.sh -M # no manifest'
                    ./dscripts/build.sh  -pM
                '''
                sh '''
                    echo 'build.sh -P # push after build'
                    ./dscripts/build.sh  -pP
                '''
                sh '''
                    echo 'build.sh -t mytag # tag, no manifest'
                    ./dscripts/build.sh  -pt mytag
                '''
                sh '''
                    echo 'build.sh -rt mytag # remove existing image (custom tag)'
                    ./dscripts/build.sh  -pr
                '''
            }
        }
    }
    post {
        always {
          sh '$sudo docker rm -f transient_registry'
        }
    }
}
