# Closes ALL live desktop notifications for this window on focus, not just kitty's own
# notify_on_cmd_finish ones - relies on undocumented kitty internals, see DESIGN.md.

def on_focus_change(boss, window, data):
    if not data['focused']:
        return
    notification_manager = boss.notification_manager
    for notification_id, cmd in list(notification_manager.in_progress_notification_commands.items()):
        if cmd.channel_id == window.id:
            notification_manager.close_notification(notification_id)
