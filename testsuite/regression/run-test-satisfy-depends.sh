#!/bin/sh
# requires a working "pdebuild"

set -e

log() {
    echo "$*"
}

log_i() {
    log "I: $*"
}

log_e() {
    log "I: $*"
}

result() {
    result=$1
    package=$2
    version=$3
    echo "[$result] $package $version" >>$RESULTFILE
}

self="$(basename "$0")"

log_i "Starting $self at $(LC_ALL=C date)"

PDEBUILD="pdebuild"

#RESULTFILE="$(readlink -f "$(basename "$0" .sh).log")"
RESULTFILE="$OUTPUT_LOGNAME"
log_i "Resetting result file $(basename "$RESULTFILE")"
: > "$RESULTFILE"
RESULTFILE="$(readlink -f "$RESULTFILE")"

WORK_DIR="satisfydepends/work"
[ -d "$WORK_DIR" ] && rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
WORK_DIR="$(readlink -f "$WORK_DIR")"

RESULT_DIR="$WORK_DIR/result"
[ -d "$RESULT_DIR" ] && rm -rf "$RESULT_DIR"
mkdir -p "$RESULT_DIR"
RESULT_DIR="$(readlink -f "$RESULT_DIR")"

for control in satisfydepends/*.control; do
    changelog=satisfydepends/$(basename $control .control).changelog
    package=$(basename $control .control | sed 's/_.*//')
    version=$(basename $control .control | sed -n 's/.*_//p')
    if [ -z "$version" ]; then
        log_e "Could not extract version for package $package/$version, skipping"
        continue
    fi
    if ! [ -e $changelog ]; then
        log_e "Could not find $changelog for package $package/$version, skipping"
        continue
    fi
    log_i "Preparing build for package $package/$version"
    package_dir="$WORK_DIR/$package"
    # cleanup
    [ -d "$package_dir" ] && rm -rf "$package_dir"
    # create package structure
    mkdir -p "$package_dir/debian"
    cp -l satisfydepends/debian/rules "$package_dir/debian"
    cp -l $changelog "$package_dir/debian/changelog"
    cp -l $control "$package_dir/debian/control"
    log_i "Building package $package/$version as \"$PDEBUILD --buildresult $RESULT_DIR -- --pkgname-logfile\" in $package_dir"
    if (cd "$package_dir"; $PDEBUILD --buildresult "$RESULT_DIR" -- --pkgname-logfile); then
        log_i "Build of $package/$version successful"
        result SUCCESS $package $version
    else
        log_i "Build of $package/$version failed"
        result FAIL $package $version
    fi
done

# cleanup
rm -rf "$RESULT_DIR"
rm -rf "$WORK_DIR"

log_i "Finishing $self at $(LC_ALL=C date)"
