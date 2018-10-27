pipeline {
    agent none
    stages {
        stage('Build and Test') {
            parallel {
                stage('Linux Server Run') {
                    agent {
                        docker {
                            image 'swift:latest'
                        }
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
                        stage('Build and Test') {
                            steps {
                                sh """
                                xcodebuild \
                                -workspace KevCodex.xcworkspace \
                                -scheme Run \
                                -configuration Debug \
                                -destination 'platform=macOS' \
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