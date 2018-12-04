#!/usr/bin/env groovy

def labels = ['armv7l', 'aarch64'] // labels for Jenkins node types we will build on
def builders = [:]
for (x in labels) {
  def label = x // Need to bind the label variable before the closure - can't do 'for (label in labels)'

  // Create a map to pass in to the 'parallel' step so we can fire all the builds at once
  builders[label] = {
    node(label) {
      try {

        stage('build') {
          deleteDir()
          checkout scm
          sh "make"
        }

        stage('test') {
        }

        stage('push') {
          sh "make push"
        }

      } catch(error) {
        throw error

      } finally {
        // Any cleanup operations needed, whether we hit an error or not
      }
    }
  }
}

parallel builders
