cask "liwu" do
  version "2.2.2"
  sha256 "b470acd0449100f4e5d2e797c1a11a07f281d795f9f6ae6acbda3e5ea3f54e39"

  url "https://github.com/urfreespace/liwu-releases/releases/download/v#{version}/Liwu-#{version}.dmg",
      verified: "github.com/urfreespace/liwu-releases/"
  name "Liwu"
  desc "Menu bar utilities with charging targets and Keep Awake"
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
