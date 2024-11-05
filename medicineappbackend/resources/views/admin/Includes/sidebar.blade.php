<ul class="navbar-nav sidebar sidebar-light accordion" id="accordionSidebar">
  <a class="sidebar-brand d-flex align-items-center justify-content-center" href="{{ route('dashboard') }}">
    <div class="sidebar-brand-icon">
      <img class="img-profile rounded-circle" src="{{ asset('images/cover.png') }}" style="min-width: 170px">
    </div>
  </a>
  <hr class="sidebar-divider my-0">
  <li class="nav-item active">
    <a class="nav-link" href="{{ route('dashboard') }}">
      <i class="fas fa-fw fa-tachometer-alt"></i>
      <span>Dashboard</span>
    </a>
  </li>
  <hr class="sidebar-divider">
  <div class="sidebar-heading">
    Health Land
  </div>
  <li class="nav-item">
    <a class="nav-link" href="{{ route('manageAccounts') }}">
      <i class="fas fa-users"></i>
      <span>Manage Accounts</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="{{ route('accountreclamation') }}">
      <i class="fas fa-file-alt"></i>
      <span>Complaint</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="{{ route('Account_creation_requests') }}">
      <i class="fas fa-clipboard-list"></i>
      <span>Manage Requests</span>
    </a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="{{ route('manageMedicines') }}">
      <i class="fas fa-pills"></i>
      <span>Manage Medicines</span>
    </a>
  </li>
  <hr class="sidebar-divider">
  <div class="version" id="version-ruangadmin">version 2.3</div>
</ul>
