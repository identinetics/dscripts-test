pipeline {
    agent any
    stages {
        stage('Build with differnt options') {
            steps {
                sh '''
                    echo 'build.sh'
                    rm conf.sh 2> /dev/null || true
                    ln -sf conf.sh.default conf.sh
                    ./dscripts/build.sh  -p
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
            }
        }
    }
}