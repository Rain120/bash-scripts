#! /bin/bash
###
 # AUTO_VERSION
 #   -> used v(major.minor.build), auto increasing one number which you used version type
 #   -> default 0.0.0
 # customVersion -> used v(customVersion)
### 
echo "--------------------------- Please Checked your current branch was clean !!!! ---------------------------"

read -p "Auto Increasing(Y/y | N/n): " AUTO_VERSION

if [[ $AUTO_VERSION = "Y" || $AUTO_VERSION = "y" ]]; then
    read -p "Usage major|minor|build(default build): " VERSION_TYPE
    if [ -e $CURRENT_VERSION ]; then
        VERSION_TYPE="build"
    fi

    echo "version type is $VERSION_TYPE"
    if [[ $VERSION_TYPE = "major" || $VERSION_TYPE = "minor" || $VERSION_TYPE = "build" ]]; then
        # CURRENT_VERSION=$(git describe --tags --abbrev=0 | awk -F. '{ print $0; }')
        CURRENT_VERSION=`git tag -l | egrep "^v[0-9]+\.[0-9]+\.[0-9]+" | cut -d"-" -f 1 | sed "s/^v//g" | sort | tail -n 1`

        if [ -e $CURRENT_VERSION ]; then
            CURRENT_VERSION="0.0.0"
        else
            MAJOR_VERSION=`git tag -l | egrep "^v[0-9]+\.[0-9]+\.[0-9]+" | sed "s/^v//g" | cut -d"." -f1 | sort -n | tail -n 1`
            MINOR_VERSION=`git tag -l | egrep "^v$MAJOR_VERSION\.[0-9]+\.[0-9]+" | sed "s/^v//g" | cut -d"." -f2 | sort -n | tail -n 1`
            BUILD_VERSION=`git tag -l | egrep "^v$MAJOR_VERSION\.$MINOR_VERSION\.[0-9]+" | sed "s/^v//g" | cut -d"." -f3 | sort -n | tail -n 1`
            CURRENT_VERSION="$MAJOR_VERSION.$MINOR_VERSION.$BUILD_VERSION"
        fi

        LAST_MAJOR=`echo $CURRENT_VERSION | cut -d"." -f 1`
        LAST_MINOR=`echo $CURRENT_VERSION | cut -d"." -f 2`
        LAST_BUILD=`echo $CURRENT_VERSION | cut -d"." -f 3`

        NEW_MAJOR=$LAST_MAJOR
        NEW_MINOR=$LAST_MINOR
        NEW_BUILD=$LAST_BUILD

        if [[  $VERSION_TYPE = "major" || -e $LAST_MAJOR ]]; then
            echo "Adding major"
            NEW_MAJOR=`echo "$LAST_MAJOR + 1" | bc`
        fi
        if [[  $VERSION_TYPE = "minor" || -e $LAST_MINOR ]]; then
            echo "Adding minor"
            NEW_MINOR=`echo "$LAST_MINOR + 1" | bc`
        fi
        if [[  $VERSION_TYPE = "build" || -e $LAST_BUILD ]]; then
            echo "Adding build"
            NEW_BUILD=`echo "$LAST_BUILD + 1" | bc`
        fi
        VERSION="v$NEW_MAJOR.$NEW_MINOR.$NEW_BUILD"
    else
        echo "Error: Usage major|minor|build"
        exit 1
    fi
else
    read -p "Input Version(Just use number, don't add a prefix of v or other words, etc.): " INPUT_VERSION
    if [ ! -n "$INPUT_VERSION" ]; then
        INPUT_VERSION="0.0.0"
    fi
    VERSION="v${INPUT_VERSION}"
fi

echo "New Version is $VERSION"

if [ -n "$1" ];then
    checkoutBranch=$1
else
    checkoutBranch=$(git branch | awk '/\*/ { print $2; }')
    # 另一种获取当前 branch_name 的方法
    # git symbolic-ref --short HEAD
fi

echo "Checkout Branch is ${checkoutBranch}"
git checkout $checkoutBranch || exit 1

# current bug all of tags
git fetch --tags

# echo "All of tag list"
# git tag -l -n
# echo "${TAG_LIST}"

# lasted tag
LATEST_TAG=$(git describe --tags `git rev-list --tags --max-count=1`)
echo "The lasted version of tag is ${LATEST_TAG}"
echo "${VERSION} will be the current tag version"

# 输入tag名称

read -p "Tag Message(short decsription + card url): " TAG_MESSAGE

git tag -a $VERSION -m $TAG_MESSAGE || exit 1

git push origin $VERSION

echo "--------------------------- Tag has Pushed !!!! ---------------------------"