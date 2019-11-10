#
# This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
# please do __NOT__ modify it manually.
#

require ["fileinto"];

# rule:[Move Spam to Junk Folder]
if header :is "X-Spam-Flag" "YES"
{
    fileinto "Junk";
}
