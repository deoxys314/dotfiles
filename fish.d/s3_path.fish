function s3_path
    string join '/' $argv | string replace --all '//' '/' | string replace --regex '^s3:/' 's3://'
end
