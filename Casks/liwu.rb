cask "liwu" do
  version "2.6.0"
  sha256 "6886909ea1e005229569e2579341b21708ff46f723cdcc9594c3955d1a99921c"

  url "https://github.com/urfreespace/liwu-releases/releases/download/v#{version}/Liwu-#{version}.dmg"
  name "Liwu"
  desc "Menu bar charge limiter, Keep Awake and menu bar icon organizer"
  homepage "https://liwu.app/"

  livecheck do
    url "https://liwu.app/appcast.xml"
    # Use shortVersionString only: the default sparkle strategy appends the build
    # number (for example, 1.0.4,162), which doesn't match the plain version in the DMG filename.
    strategy :sparkle, &:short_version
  end

  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Liwu.app"

  # Named dependencies cover major releases only; enforce the minor boundary before installation.
  preflight_steps do
    run "/bin/sh", args: ["-c", <<~SH]
      version=$(/usr/bin/sw_vers -productVersion)
      major=${version%%.*}
      rest=${version#*.}
      minor=${rest%%.*}
      if [ "${major}" -lt 26 ] || { [ "${major}" -eq 26 ] && [ "${minor}" -lt 7 ]; }; then
        echo "Liwu 2 requires macOS 26.7 or later. Download Liwu 1 at https://liwu.app/legacy." >&2
        exit 1
      fi
    SH
  end

  # Use the signed application's release-and-unregister flow before Homebrew removes it.
  # Keep user preferences and licenses. A cleanup failure must abort removal.
  uninstall quit:   "com.liwu.app",
            script: {
              executable:   "/usr/bin/env",
              args:         ["LIWU_UNINSTALL=1", "#{appdir}/Liwu.app/Contents/MacOS/Liwu"],
              sudo:         false,
              must_succeed: true,
            }
end
