pipeline {
    agent none
    stages {
        stage('Build and Test') {
            parallel {
                stage('Linux Server Run') {
                    agent {
                        // TODO: Figure out how to use docker env (have to install uuid-dev in docker container)
                        label 'master'
                    }
                    environment {
                        PATH = '/home/kirby/bin:/home/kirby/.local/bin:/home/kirby/swift-4.1.2-RELEASE-ubuntu16.04/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
                    }
                    stages {
                        stage('Update Package') {
                            steps {
                                sh 'cd KevCodexServer && swift package update'
                            }
                        }
                        stage('Build') {
                            steps {
                                sh 'cd KevCodexServer && swift package clean'
                                sh 'cd KevCodexServer && swift build'
                            }
                        }
                        stage('Test') {
                            steps {
                                sh 'cd KevCodexServer && swift test'
                            }
                        }
                    }
                }
                stage('Mac Server Run') {
                    agent {
                        label 'ios-slave'
                    }
                    environment {
                        PATH = "/usr/local/bin:/usr/local/sbin:$PATH"
                    }
                    post {
                        success {
                            junit 'build/reports/junit.xml'
                        }
                    }
                    stages {
                        stage('Update Package') {
                            steps {
                                sh 'cd KevCodexServer && swift package update'
                            }
                        }
                        stage("Swift Build") {
                            steps {
                                sh 'cd KevCodexServer && swift build'
                            }
                        }
                        stage('Mac Generate Xcode') {
                            steps {
                                sh 'cd KevCodexServer && swift package generate-xcodeproj'
                            }
                        }
                        stage('Build and Test') {
                            steps {
                                sh """
                                xcodebuild \
                                -workspace KevCodex.xcworkspace \
                                -scheme Run \
                                -destination 'platform=macOS' \
                                build \
                                test \
                                | xcpretty -r junit
                                """
                            }
                        }
                    }
                }
                stage('Mac iOS Run') {
                    agent {
                        label 'ios-slave'
                    }
                    environment {
                        PATH = "/usr/local/bin:/usr/local/sbin:$PATH"
                    }
                    post {
                        success {
                            junit 'build/reports/junit.xml'
                        }
                    }
                    stages {
                        stage('Build and Test') {
                            steps {
                                sh """
                                xcodebuild \
                                -workspace KevCodex.xcworkspace \
                                -scheme GameViewer \
                                -configuration Debug \
                                -destination 'OS=12.0,name=iPhone 8' \
                                test \
                                | xcpretty -r junit
                                """
                            }
                        }
                    }
                }
            }
        }
    }
}