# Run with: brew ruby tests/uninstall.rb
# Only the temporary fake executable runs; no real app or service is changed.
require "cask/cask_loader"
require "tmpdir"
require "fileutils"

Dir.mktmpdir("liwu-uninstall-") do |folder|
  appdir = Pathname(folder)/"Applications with spaces"
  executable = appdir/"Liwu.app/Contents/MacOS/Liwu"
  FileUtils.mkdir_p(executable.dirname)
  cask = Cask::CaskLoader.load(Pathname(__dir__).parent/"Casks/liwu.rb",
                             config: Cask::Config.new(explicit: { appdir: }))
  artifacts = cask.artifacts.to_a
  uninstall = artifacts.find { |artifact| artifact.is_a?(Cask::Artifact::Uninstall) }
  app = artifacts.find { |artifact| artifact.is_a?(Cask::Artifact::App) }
  raise "Cleanup must precede app removal" unless artifacts.index(uninstall) < artifacts.index(app)
  raise "Normal quit must precede cleanup" unless uninstall.directives[:quit] == "com.liwu.app"

  [false, true].each do |upgrade|
    executable.write("#!/bin/sh\n[ \"$LIWU_UNINSTALL\" = 1 ] || exit 9\nexit 0\n")
    executable.chmod(0o755)
    uninstall.uninstall_phase(command: SystemCommand, quit: false, upgrade:)
    executable.write("#!/bin/sh\nexit 7\n")
    begin
      uninstall.uninstall_phase(command: SystemCommand, quit: false, upgrade:)
      raise "Failed cleanup was ignored"
    rescue ErrorDuringExecution => error
      raise unless error.status.exitstatus == 7
    end
  end
  raise "Test unexpectedly removed app" unless executable.exist?
end
puts "PASS: cleanup before removal, environment/path handling, success and failure on uninstall/upgrade"
