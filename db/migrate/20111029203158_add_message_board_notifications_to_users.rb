class AddMessageBoardNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :message_board_notification, :boolean, default: false, null: false
  end
end
