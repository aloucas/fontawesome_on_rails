module FontawesomeOnRails
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path '../../templates', __FILE__

      desc 'Add fontawesome require to application.css'

      class_option :skip_git,
        type: :boolean,
        aliases: '-g',
        default: false,
        desc: 'Skip Git keeps'

      def inject_fontawesome
        require_fontawesome = "//= require fontawesome\n"

        if manifest.exist?
          manifest_contents = File.read(manifest)

          if match = manifest_contents.match(/\/\/=\s+require\s+turbolinks\s+\n/)
            inject_into_file manifest, require_fontawesome, { after: match[0] }
          elsif match = manifest_contents.match(/\/\/=\s+require_tree[^\n]*/)
            inject_into_file manifest, require_fontawesome, { before: match[0] }
          else
            append_file manifest, require_fontawesome
          end
        else
          create_file manifest, require_fontawesome
        end
      end

      private

      def manifest
        Pathname.new(destination_root).join('app/assets/stylesheets', 'application.css')
      end
    end
  end
end
