class ssh {
  class { '::ssh::package': } ->
  class { '::ssh::config': } ->
  class { '::ssh::service':} ->
  Class['ssh']
}
