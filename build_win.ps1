param(
    [string]$latest_tag,
    [string]$github_api_token
)

Write-Output "APP_VERSION=`"$latest_tag`"" >> src/utils/consts.py
Write-Output "GITHUB_API_TOKEN=`"$github_api_token`"" >> src/utils/consts.py

pyinstaller --name commonBird `
    --add-data "common_bird_app.tcss:." `
    --add-data "public_key.pem:." `
    --exclude-module pandas `
    --exclude-module numpy `
    --exclude-module textual-dev `
    --exclude-module pyinstaller `
    cli.py

npm i markdown-to-html-cli -g

markdown-to-html -i "README.md" -o "dist/commonBird/README.html"

python taxon_map_preview.py --map_file "ch4_to_eb_taxon_map.json" --output_path "dist/commonBird/taxon_map_preview.html"

Copy-Item -Path "res" -Destination "dist/commonBird/res" -Recurse
Copy-Item -Path "database" -Destination "dist/commonBird/database" -Recurse
Copy-Item -Path "README.md" -Destination "dist/commonBird/README.md"
Copy-Item -Path "changelog.md" -Destination "dist/commonBird/changelog.md"

# compress the build
Compress-Archive -Path "dist/commonBird" -DestinationPath "commonBird_win_x64.zip"