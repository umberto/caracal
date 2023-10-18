require 'caracal/abstract_header_and_footer'

module Caracal
  class Footer < AbstractHeaderAndFooter
    def relationship_params
      { target: "footer#{index}.xml", type: :footer, owner: self }
    end
  end
end
