#!/bin/sh

testNothing() {
    assertEquals "This file has CRLF end lines" 1 `file crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file lf.txt | grep -c "terminators"`

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
}

#All of these does not work with GIT v1.7.1 on Linux
testGitAttributesLf() {
    echo $'* text eol=lf\n*.txt text\n' > "${0%/*}/../.gitattributes"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    if [[ `git --version | cut -d '.' -f -2` < 'git version 1.8' ]]; then
        __shunit_skip=$SHUNIT_TRUE
    fi
    assertEquals "This file does not have CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
}

#All of these does not work with GIT v1.7.1 on Linux
testGitAttributesAuto() {
    echo $'* text auto\n*.txt text\n' > "${0%/*}/../.gitattributes"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    if [[ `git --version | cut -d '.' -f -2` < 'git version 1.8' ]]; then
        __shunit_skip=$SHUNIT_TRUE
    fi
    assertEquals "This file does not have CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
}

testGitConfigEol() {
    git config core.eol lf && \
    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
}

testGitConfigInput() {
    git config core.autocrlf input && \
    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    assertEquals "This file has CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
}

testGitConfigTrue() {
    git config core.autocrlf true && \
    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    assertEquals "This file has CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
}

testGitConfigTrueAndSafe() {
    git config core.autocrlf true && \
    git config core.safeocrlf true && \
    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    assertEquals "This file has CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
}
testGitConfigInputAndSafe() {
    git config core.autocrlf input && \
    git config core.safeocrlf true && \
    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
    assertEquals "This file has CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
}

. "${0%/*}/base.sh"