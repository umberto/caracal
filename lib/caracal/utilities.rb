# frozen_string_literal: true

# We're using this strategy borrowed from ActiveSupport to
# make command syntax a little more flexible. In a perfect
# world we'd just use the double splat feature of Ruby, but
# support for that is pretty limited at this point, so we're
# going the extra mile to be cool.
#
module Caracal
  class Utilities
    def self.extract_options!(args)
      if args.last.is_a?(Hash)
        args.pop.dup
      else
        {}
      end
    end
  end
end
