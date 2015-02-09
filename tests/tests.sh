#!/bin/sh

testNothing() {
    assertEquals "This file has CRLF end lines" 1 `file crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file lf.txt | grep -c "terminators"`

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

testGitAttributesLf() {
    echo $'* text eol=lf\n*.txt text\n' > "${0%/*}/../.gitattributes"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file does not have CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}


testGitAttributesAuto() {
    echo $'* text auto\n*.txt text\n' > "${0%/*}/../.gitattributes"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file does not have CRLF end lines" 0 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

# It does not work with OSX and GIT v2.2.2 and v1.9.3
testGitConfigEol() {
    echo $'[core]\n\tcore.eol = lf\n' > "${0%/*}/../.gitconfig"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

# It does not work with OSX and GIT v2.2.2 and v1.9.3
testGitConfigInput() {
    echo $'[core]\n\tcore.autocrlf = input\n' > "${0%/*}/../.gitconfig"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

# It does not work with OSX and GIT v2.2.2 and v1.9.3
testGitConfigTrue() {
    echo $'[core]\n\tcore.autocrlf = true\n' > "${0%/*}/../.gitconfig"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

# It does not work with OSX and GIT v2.2.2 and v1.9.3
testGitConfigTrueAndSafe() {
    echo $'[core]\n\tcore.autocrlf = true\n\tcore.safeocrlf = true\n' > "${0%/*}/../.gitconfig"

    git add -A && git commit -m 'test' &> /dev/null && git push origin test &> /dev/null && \
    git clone $(git config remote.origin.url) tmprepo &> /dev/null && cd tmprepo && \
    git checkout -b test origin/test &> /dev/null && cd ..
    assertEquals "This file has CRLF end lines" 1 `file tmprepo/crlf.txt | grep -c "CRLF"`
    assertEquals "This file has CR end lines" 1 `file tmprepo/cr.txt | grep -c " CR "`
    assertEquals "This file does not have other then LF end lines" 0 `file tmprepo/lf.txt | grep -c "terminators"`
}

. "${0%/*}/base.sh"