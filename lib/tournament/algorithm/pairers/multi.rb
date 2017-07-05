module Tournament
  module Algorithm
    module Pairers
      # Modular pairer for combining multiple pairing algorithms.
      module Multi
        extend self

        # Generic way of combining multiple pairing algorithms.
        #
        # Given a set of pair functions, generate pairs using each of them and
        # use the block to determine a value for this pairing. The function will
        # return the pairing generated that produced the highest score.
        #
        # @param pair_funcs [Array<lambda>] the array of pairers
        # @yieldparam pairings [] a set of pairings generated by +pair_funcs+
        # @yieldreturn [Number] a score for the set of pairings
        # @return the set of pairings with the highest score
        def pair(pair_funcs)
          # Score all pairings
          pairings = pair_funcs.map do |pair_func|
            matches = pair_func.call
            score = yield matches

            [matches, score]
          end

          # Use the pairings with the highest score
          pairings.max_by { |pair| pair[1] }.first
        end
      end
    end
  end
end