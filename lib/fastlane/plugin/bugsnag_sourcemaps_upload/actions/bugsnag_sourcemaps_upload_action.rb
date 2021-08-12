require 'fastlane/action'
require_relative '../helper/bugsnag_sourcemaps_upload_helper'

module Fastlane
  module Actions
    class BugsnagSourcemapsUploadAction < Action
      def self.run(params)
        api_key = params[:api_key]
        app_version = params[:app_version]
        app_version_code = params[:app_version_code]
        app_bundle_version = params[:app_bundle_version]
        code_bundle_id = params[:code_bundle_id]
        platform = params[:platform]
        dir = params[:sourcemaps_dir]
        sourcemap = params[:sourcemap]
        bundle = params[:bundle]
        overwrite = params[:overwrite]
        generate_sourcemaps = params[:generate_sourcemaps]
        entry_file = params[:entry_file]
        endpoint = params[:endpoint]
        project_root = params[:project_root]

        path = ""
        if sourcemap
          path = "#{dir}/#{sourcemap}".to_s
        else
          path = "#{dir}/#{platform}.bundle.map".to_s
        end
        bundle_path = ""
        if bundle
          bundle_path = "#{dir}/#{bundle}".to_s
        else
          bundle_path = "#{dir}/#{platform}.bundle".to_s
        end

        if generate_sourcemaps
          Helper::BugsnagSourcemapsUploadHelper.create_bundle(platform, entry_file, path, bundle_path)
        end
        Helper::BugsnagSourcemapsUploadHelper.upload_bundle(api_key, platform, app_version, app_version_code, app_bundle_version, code_bundle_id, path, bundle_path, overwrite, endpoint, project_root)
      end

      def self.description
        "Upload sourcemaps to Bugsnag"
      end

      def self.authors
        ["Evgrafov Denis", "Ivan Sokolovskii"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Helps to generate and upload React-Native sourcemaps to Bugsnag"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_key,
                                  env_name: "BUGSNAG_API_KEY",
                               description: "Bugsnag API key",
                                  optional: false,
                              verify_block: proc do |value|
                                UI.user_error!("No Bugsnag API key given, pass using `api_key: 'key'`") unless value && !value.empty?
                              end,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :app_version,
                                  env_name: "BUGSNAG_SOURCEMAPS_APP_VERSION",
                               description: "Target app version",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :app_version_code,
                                  env_name: "BUGSNAG_SOURCEMAPS_APP_VERSION_CODE",
                               description: "android app version code",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :app_bundle_version,
                                  env_name: "BUGSNAG_SOURCEMAPS_APP_BUNDLE_VERSION",
                               description: "ios bundle version",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :code_bundle_id,
                                  env_name: "BUGSNAG_SOURCEMAPS_CODE_BUNDLE",
                               description: "Codepush bundle ID",
                                  optional: true,
                                     type: String),
          FastlaneCore::ConfigItem.new(key: :platform,
                                  env_name: "BUGSNAG_SOURCEMAPS_PLATFORM",
                               description: "Platform",
                                  optional: true,
                             default_value: 'ios',
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :sourcemaps_dir,
                                  env_name: "BUGSNAG_SOURCEMAPS_DIR",
                               description: "Bugsnag sourcemaps directory",
                                  optional: true,
                             default_value: "/tmp",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :sourcemap,
                                  env_name: "BUGSNAG_SOURCEMAPS_NAME",
                               description: "Override path(relative to sourcemaps_dir) to sourcemaps, default is platform-specific",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :bundle,
                                  env_name: "BUGSNAG_SOURCEMAPS_BUNDLE_NAME",
                               description: "Override path(relative to sourcemaps_dir) bundle to upload, default is platform-specific",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :overwrite,
                                  env_name: "BUGSNAG_SOURCEMAPS_OVERWRITE",
                               description: "Overwrite existing sourcemaps in Bugsnag",
                                  optional: true,
                             default_value: true,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :generate_sourcemaps,
                                  env_name: "BUGSNAG_SOURCEMAPS_GENERATE",
                               description: "Generate React-Native sourcemaps",
                                  optional: true,
                             default_value: true,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :entry_file,
                                  env_name: "BUGSNAG_SOURCEMAPS_ENTRY_FILE",
                               description: "React Native index file for soucemaps generation",
                                  optional: true,
                             default_value: "index.js",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :endpoint,
                                  env_name: "BUGSNAG_SOURCEMAPS_ENDPOINT",
                               description: "Bugsnag endpoint(when using Bugsnag On-premise)",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :project_root,
                                  env_name: "BUGSNAG_SOURCEMAPS_PROJECT_ROOT",
                               description: "the top level directory of your project",
                                  optional: true,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
