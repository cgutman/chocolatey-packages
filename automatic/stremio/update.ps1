﻿import-module au
import-module Wormies-AU-Helpers

$releases = "https://www.stremio.com"
$regex = "(https://www.strem.io/download.*)"
$regex_version = "https://dl.strem.io/win/v[\d\.]+/Stremio\+(?<Version>[\d\.]+).exe"

function global:au_GetLatest {
     $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing
	 $url = $download_page.links.href -match $regex | select -First 1
     $url_latestVersion = Get-RedirectedUrl "$url"
     $url_latestVersion -match $regex_version | Out-Null

     return @{ Version = $matches.Version ; URL32 = $url_latestVersion }
}

function global:au_SearchReplace {
    @{
        "tools\chocolateyInstall.ps1" = @{
			"(^(\s)*url\s*=\s*)('.*')" = "`$1'$($Latest.URL32)'"
            "(^(\s)*checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

update