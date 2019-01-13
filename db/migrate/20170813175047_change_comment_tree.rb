class ChangeCommentTree < ActiveRecord::Migration
  class Comment < ActiveRecord::Base
  end

  def up
    add_column :comments, :blogpost_id, :integer
    # originally, every comment had a predecessor, which was either another comment or a blogpost
    # in the future, every comment is directly related to a blogpost and may have another comment
    # as predecessor
    change_column_null :comments, :predecessor_id, true

    direct_comments = Comment.where(predecessor_type: 'Blogpost')
    direct_comments.each do |comment|
      comment.blogpost_id = comment.predecessor_id
      comment.predecessor_type = ''
      comment.predecessor_id = nil
      if not comment.save then
        raise 'Unable to migrate comments: Unable to save comment #' + comments.id
      end
      self.migrate_child_comments comment
    end

    orphaned_comments = Comment.where(blogpost_id: nil)
    orphaned_comments.each do |comment|
      comment.destroy
    end

    change_column_null :comments, :blogpost_id, false # each comment must belong to a blogpost
    remove_column :comments, :predecessor_type

  end

  def migrate_child_comments(parent)
    children = Comment.where(predecessor_type: 'Comment', predecessor_id: parent.id)
    if children.size == 0 then
      return
    end
    children.each do |comment|
      comment.blogpost_id = parent.blogpost_id;
      comment.predecessor_type = ''
      if not comment.save then
        raise 'Unable to migrate comments: Unable to save comment #' + comments.id
      end
      self.migrate_child_comments comment
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
