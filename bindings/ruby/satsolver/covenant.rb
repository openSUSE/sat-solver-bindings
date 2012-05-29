#
# satsolver/covenant.rb
#

module Satsolver
  class Covenant
    def to_s
      case cmd
      when INCLUDE_SOLVABLE then "include #{solvable}"
      when EXCLUDE_SOLVABLE then "exclude #{solvable}"
      when INCLUDE_SOLVABLE_NAME then "include by name #{name}"
      when EXCLUDE_SOLVABLE_NAME then "exclude by name #{name}"
      when INCLUDE_SOLVABLE_PROVIDES then "include by relation #{relation}"
      when EXCLUDE_SOLVABLE_PROVIDES then "exclude by relation #{relation}"
      else "<NONE>"
      end
    end
  end
end
