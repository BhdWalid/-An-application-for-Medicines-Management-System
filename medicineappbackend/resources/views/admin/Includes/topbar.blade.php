<nav class="navbar navbar-expand navbar-light bg-navbar topbar mb-4 static-top">
          <button id="sidebarToggleTop" class="btn btn-link rounded-circle mr-3">
            <i class="fa fa-bars"></i>
          </button>
        <div class="text-white big" style="margin-left:100px;"><b></b></div>
        <ul class="navbar-nav ml-auto">
    <li class="nav-item dropdown no-arrow mx-1">
      <div class="nav-link dropdown-toggle clickable" id="alertsDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="fas fa-bell fa-fw"></i>
        <span class="badge badge-danger badge-counter">@if($count >0){{$count}}+@endif</span>
      </div>
      <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="alertsDropdown">
        <h6 class="dropdown-header">
          Alerts Center
        </h6>
        <span class="dropdown-item text-center small text-gray-500">Nothing to show</span>
      </div>
    </li>
    <div class="topbar-divider d-none d-sm-block"></div>
    <li class="nav-item dropdown no-arrow">
      <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <img class="img-profile rounded-circle" src="{{ asset('img/user-icn.png')}}" style="max-width: 60px">
        <span class="ml-2 d-none d-lg-inline text-white small"><b>Welcome {{$username}}</b></span>
      </a>
      <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
        <a class="dropdown-item" >
          <i class="fas fa-lock fa-sm fa-fw mr-2 text-gray-400"></i>
          Update Password
        </a>
        <!--
                <a class="dropdown-item" href="#">
                  <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                  Settings
                </a>
                <a class="dropdown-item" href="#">
                  <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
                  Activity Log
                </a> -->
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="{{route('logout')}}">
          <i class="fas fa-power-off fa-fw mr-2 text-danger"></i>
          Logout
        </a>
      </div>
    </li>
  </ul>
</nav>
