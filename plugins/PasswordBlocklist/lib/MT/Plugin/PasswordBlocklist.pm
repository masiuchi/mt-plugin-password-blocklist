package MT::Plugin::PasswordBlocklist;
use strict;
use warnings;
use utf8;

sub cb_cms_save_filter_author {
    my ( $cb, $app ) = @_;
    my $lc_password = lc $app->param('pass');
    return 1 if !defined $lc_password || $lc_password eq '';

    my $plugin = $app->component('PasswordBlocklist')
      or die MT->translate('保存できませんでした: プラグインエラーです。');

    my $blocklist = $plugin->get_config_value('password_blocklist');
    return 1 if !defined $blocklist || $blocklist eq '';

    for my $block_password ( split /\r?\n/, $blocklist ) {
        next if !defined $block_password || $block_password eq '';
        if ( $lc_password eq lc $block_password ) {
            return $cb->trans_error(
                '保存できませんでした: 新しく設定しようとしたパスワードは禁止パスワードリストに含まれています。違うパスワードを設定してください。'
            );
        }
    }
    return 1;
}

1;
