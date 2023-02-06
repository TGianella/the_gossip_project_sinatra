class Gossip
  attr_accessor :author, :content, :comments

  def initialize(author, content)
    @author = author
    @content = content
  end

  def save
    CSV.open('db/gossip.csv', 'ab') do |csv|
      csv << [author, content]
    end
    CSV.open('db/comments.csv', 'ab') do |csv|
      csv << []
    end
  end

  def self.all
    all_gossips = []
    CSV.foreach('db/gossip.csv') do |gossip|
      all_gossips << Gossip.new(*gossip)
    end
    all_gossips
  end

  def self.find(id)
    Gossip.new(*CSV.read('db/gossip.csv')[id])
  end

  def self.update(id, new_author, new_content)
    CSV.open('db/updated_gossip.csv', 'wb') do |csv_write|
      CSV.foreach('db/gossip.csv').with_index(1) do |row, row_number|
        csv_write << if row_number == id.to_i
                       [new_author, new_content]
                     else
                       row
                     end
      end
    end
    File.delete('db/gossip.csv')
    File.rename('db/updated_gossip.csv', 'db/gossip.csv')
  end

  def self.add_comment(id, comment_author, comment_content)
    CSV.open('db/updated_gossip.csv', 'wb') do |csv_write|
      CSV.foreach('db/gossip.csv').with_index(1) do |row, row_number|
        if row_number == id.to_i
          p row[2]
          row[2].to_a << [comment_author, comment_content]
          csv_write << row
        else
          csv_write << row
        end
      end
    end
    File.delete('db/gossip.csv')
    File.rename('db/updated_gossip.csv', 'db/gossip.csv')
  end
end
