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
        minified_url = params[:minified_url]
        overwrite = params[:overwrite]
        strip = params[:strip]
        wildcard_prefix = params[:wildcard_prefix]
        generate_sourcemaps = params[:generate_sourcemaps]
        upload_sources = params[:upload_sources]
        upload_modules = params[:upload_modules]
        entry_file = params[:entry_file]
        endpoint = params[:endpoint]

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
        Helper::BugsnagSourcemapsUploadHelper.upload_bundle(api_key, platform, app_version, app_version_code, app_bundle_version, code_bundle_id, path, bundle_path, minified_url, strip, overwrite, wildcard_prefix, upload_sources, upload_modules, endpoint)
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
          FastlaneCore::ConfigItem.new(key: :minified_url,
                                  env_name: "BUGSNAG_SOURCEMAPS_MINIFIED_URL",
                               description: "Override Bugsnag mified url, default is platform specific",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :overwrite,
                                  env_name: "BUGSNAG_SOURCEMAPS_OVERWRITE",
                               description: "Overwrite existing sourcemaps in Bugsnag",
                                  optional: true,
                             default_value: true,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :strip,
                                  env_name: "BUGSNAG_SOURCEMAPS_STRIP_PROJECT_ROOT",
                               description: "Strip project root",
                                  optional: true,
                             default_value: true,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :wildcard_prefix,
                                  env_name: "BUGSNAG_SOURCEMAPS_WILDCARD_PREFIX",
                               description: "Add wildcard prefix for Bugsnag",
                                  optional: true,
                             default_value: false,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :generate_sourcemaps,
                                  env_name: "BUGSNAG_SOURCEMAPS_GENERATE",
                               description: "Generate React-Native sourcemaps",
                                  optional: true,
                             default_value: true,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :upload_sources,
                                  env_name: "BUGSNAG_SOURCEMAPS_UPLOAD_MODULES",
                               description: "Upload source files referenced by the source map",
                                  optional: true,
                             default_value: true,
                                      type: Boolean),
          FastlaneCore::ConfigItem.new(key: :upload_modules,
                                  env_name: "BUGSNAG_SOURCEMAPS_UPLOAD_MODULES",
                               description: "Upload dependency files referenced by the source map",
                                  optional: true,
                             default_value: false,
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
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
