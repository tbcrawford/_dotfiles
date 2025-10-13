#
# Expand or extract bundled & compressed files
#
# Universal archive extraction utility that automatically detects file format
# and uses appropriate extraction tool. Supports tar, zip, 7z, rar, gzip, bzip2,
# and other common archive formats. Processes multiple files in sequence.
#
# @param $argv - One or more archive files to extract
# @return 0 on success, error messages for unsupported formats or missing files
# @example extract archive.tar.gz
# @example extract file1.zip file2.tar.bz2 file3.7z
#
function extract --description "Expand or extract bundled & compressed files"
    for file in $argv
        if test -f $file
            switch $file
                case "*.tar.bz2"
                    tar xjf $file
                case "*.tar.gz" "*.tgz"
                    tar xzf $file
                case "*.bz2"
                    bunzip2 $file
                case "*.rar"
                    rar x $file
                case "*.gz"
                    gunzip $file
                case "*.tar"
                    tar xf $file
                case "*.tbz2"
                    tar xjf $file
                case "*.tgz"
                    tar xzf $file
                case "*.zip"
                    unzip $file
                case "*.Z"
                    uncompress $file
                case "*.7z"
                    7z x $file
                case '*'
                    echo "$file cannot be extracted via extract"
            end
        else
            echo >&2 "$file is not a valid file"
        end
    end
end
