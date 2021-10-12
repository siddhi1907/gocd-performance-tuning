#!bin/bash

    yum install -y git git-daemon
    git config --global user.name "Perf Tester"
    git config --global user.email "perf-tester@test.com"
    for COUNTER in $(seq 1 $NUMBER_OF_REPOS)
    do
      mkdir -p /var/repos/repo-$COUNTER
      cd /var/repos/repo-$COUNTER
        git init .
        touch ".git/git-daemon-export-ok"
        touch 'file'
        git add . &> /dev/null
        git commit -m 'Initial commit' --author 'foo <foo@bar.com>' &> /dev/null
        echo repo-$COUNTER created....
      cd -
    done

    #Create a common repo for pipelines to share

    mkdir -p /var/repos/repo-common
    cd /var/repos/repo-common
      git init .
      touch ".git/git-daemon-export-ok"
      touch 'file'
      git add . &> /dev/null
      git commit -m 'Initial commit' --author 'foo <foo@bar.com>' &> /dev/null
      echo `date +%s` > file
      git add .;git commit -m 'This is commit at $(date)' --author 'foo <foo@bar.com>'; git gc;
    cd -

    git daemon --base-path=/var/repos/ --detach --syslog --export-all
    current_time=`date +%s`
    test_end_time=$(($current_time + $TEST_DURATION))
    while [ $current_time -lt $test_end_time ]
    do
        for COUNTER in $(seq 1 $NUMBER_OF_REPOS)
        do
          cd /var/repos/repo-$COUNTER
          echo `date +%s` > file
          git add .;git commit -m 'This is commit at $(date)' --author 'foo <foo@bar.com>'; git gc;
        done
        sleep $GIT_COMMIT_INTERVAL
        current_time=`date +%s`

    #initate a git repo for config-repos
    mkdir -p /var/repos/config-repo-git
    cd /var/repos/config-repo-git
      git init .
      touch ".git/git-daemon-export-ok"
      touch 'file'
      git add . &> /dev/null
      git commit -m 'Initial commit' --author 'foo <foo@bar.com>' &> /dev/null
      echo `date +%s` > file
      git add .;git commit -m 'This is commit at $(date)' --author 'foo <foo@bar.com>'; git gc;
    cd -
    done