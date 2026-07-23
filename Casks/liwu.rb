cask "liwu" do
  version "1.0.3"
  sha256 "4a6dbea4f18413816e24908bb099624821d7cbd59e14a8281768a707185601b6"

  url "https://github.com/urfreespace/liwu-releases/releases/download/v#{version}/Liwu-#{version}.dmg",
      verified: "github.com/urfreespace/liwu-releases/"
  name "Liwu"
  desc "Menu bar battery charge limiter"
  homepage "https://liwu.app/"

  livecheck do
    url "https://liwu.app/appcast.xml"
    # Use shortVersionString only: the default sparkle strategy appends the build
    # number (1.0.3,128), which doesn't match the plain version in the DMG filename.
    strategy :sparkle do |item|
      item.short_version
    end
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Liwu.app"

  # zap is intentionally omitted: helper/config on-disk locations are not guessed;
  # to be added once confirmed with the developer.
end
