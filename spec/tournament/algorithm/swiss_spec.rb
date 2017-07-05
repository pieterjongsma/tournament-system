require 'tournament/algorithm/swiss'

describe Tournament::Algorithm::Swiss do
  describe '#minimum_rounds' do
    it 'works' do
      expect(described_class.minimum_rounds(2)).to eq(1)
      expect(described_class.minimum_rounds(3)).to eq(2)
      expect(described_class.minimum_rounds(4)).to eq(2)
      expect(described_class.minimum_rounds(9)).to eq(4)
    end
  end
  describe '#group_teams_by_score' do
    it 'handles all scores being identical' do
      scores = Hash.new(0)

      groups = described_class.group_teams_by_score([1], scores)
      expect(groups).to eq([[1]])

      groups = described_class.group_teams_by_score([1, 2], scores)
      expect(groups).to eq([[1, 2]])

      groups = described_class.group_teams_by_score([1, 2, 3], scores)
      expect(groups).to eq([[1, 2, 3]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4], scores)
      expect(groups).to eq([[1, 2, 3, 4]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4, 5], scores)
      expect(groups).to eq([[1, 2, 3, 4, 5]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4, 5, 6], scores)
      expect(groups).to eq([[1, 2, 3, 4, 5, 6]])
    end

    it 'handles all scores being unique' do
      scores = { 1 => 6, 2 => 5, 3 => 4, 4 => 3, 5 => 2, 6 => 1 }

      groups = described_class.group_teams_by_score([1], scores)
      expect(groups).to eq([[1]])

      groups = described_class.group_teams_by_score([1, 2], scores)
      expect(groups).to eq([[1], [2]])

      groups = described_class.group_teams_by_score([1, 2, 3], scores)
      expect(groups).to eq([[1], [2], [3]])

      groups = described_class.group_teams_by_score([1, 2, 3, 4], scores)
      expect(groups).to eq([[1], [2], [3], [4]])
    end

    it 'handles nil players' do
      scores = { 1 => 4, 2 => 4, 3 => 2 }
      groups = described_class.group_teams_by_score([1, 2, 3, nil], scores)
      expect(groups).to eq([[1, 2], [3], [nil]])
    end

    it 'sorts group by score' do
      scores = { 1 => 6, 2 => 6, 3 => 4, 4 => 8, 5 => 4, 6 => 2 }
      groups = described_class.group_teams_by_score([1, 2, 3, 4, 5, 6], scores)
      expect(groups).to eq([[4], [1, 2], [3, 5], [6]])
    end
  end

  describe '#merge_small_groups' do
    it 'works for one large group' do
      groups = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]]

      described_class.merge_small_groups(groups, 4)

      expect(groups).to eq([[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]])
    end

    it 'works for many small groups' do
      groups = [[1, 2, 3], [4, 5], [6, 7], [8, 9],
                [10, 11], [12, 13, 14], [15, 16]]

      described_class.merge_small_groups(groups, 4)

      expect(groups).to eq([[1, 2, 3, 4, 5], [6, 7, 8, 9],
                            [10, 11, 12, 13, 14, 15, 16]])
    end

    it 'works for large min_size' do
      groups = [[1, 2, 3], [4, 5], [6, 7], [8, 9],
                [10, 11], [12, 13, 14], [15, 16]]

      described_class.merge_small_groups(groups, 8)

      expect(groups).to eq([[1, 2, 3, 4, 5, 6, 7, 8,
                             9, 10, 11, 12, 13, 14, 15, 16]])
    end

    it 'works for exactly min_size teams' do
      groups = [[1], [2], [3, 4], [5], [6, 7], [8]]

      described_class.merge_small_groups(groups, 8)

      expect(groups).to eq([[1, 2, 3, 4, 5, 6, 7, 8]])
    end

    it 'works for too few teams for min_size' do
      groups = [[1, 2], [3, 4], [5, 6, 7]]

      described_class.merge_small_groups(groups, 8)

      expect(groups).to eq([[1, 2, 3, 4, 5, 6, 7]])
    end

    it 'handles nil players' do
      groups = [[1, 2], [3, 4], [5, 6, 7], [nil]]

      described_class.merge_small_groups(groups, 4)

      expect(groups).to eq([[1, 2, 3, 4], [5, 6, 7, nil]])
    end
  end

  describe '#rollover_groups' do
    it 'works for many odd groups' do
      groups = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4, 5, 6], [7, 8], [9, 10, 11, 12]])
    end

    it 'works for alternating odd-even' do
      groups = [[1, 2, 3], [4, 5], [6, 7, 8], [9, 10]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4], [5, 6, 7, 8], [9, 10]])
    end

    it 'works for odd even* odd' do
      groups = [[1, 2, 3], [4, 5], [6, 7], [8, 9], [10, 11, 12]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4], [5, 6], [7, 8], [9, 10, 11, 12]])
    end

    it 'works for groups with one player' do
      groups = [[1], [2], [3], [4]]

      described_class.rollover_groups(groups)

      expect(groups).to eq([[1, 2], [3, 4]])
    end
  end
end