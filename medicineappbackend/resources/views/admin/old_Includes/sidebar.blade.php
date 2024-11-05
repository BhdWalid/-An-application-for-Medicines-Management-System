 <ul class="navbar-nav sidebar sidebar-light accordion " id="accordionSidebar">
   <a class="sidebar-brand d-flex align-items-center justify-content-center" href="{{route('dashboard')}}">
     <div class="sidebar-brand-icon">
 
       ATTE<span style="color:rgba(0,172,193,1);">NTIC</span>
     </div>
   </a>
   <hr class="sidebar-divider my-0">
   <li class="nav-item active">
     <a class="nav-link" href="index.php">
       <i class="fas fa-fw fa-tachometer-alt"></i>
       <span>Dashboard</span></a>
   </li>
   <hr class="sidebar-divider">
   <div class="sidebar-heading">
     Study
   </div>
   <li class="nav-item">
     <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseBootstrap" aria-expanded="true" aria-controls="collapseBootstrap">
       <i class="fas fa-chalkboard"></i>
       <span>Manage Study</span>
     </a>
     <div id="collapseBootstrap" class="collapse" aria-labelledby="headingBootstrap" data-parent="#accordionSidebar">
       <div class="bg-white py-2 collapse-inner rounded">
         <h6 class="collapse-header">Manage Moduls</h6>
         <a class="collapse-item" href="{{route('manageModule')}}">Manage Moduls</a>
         <a class="collapse-item" href="{{route('manageModuleSections')}}">Manage Sections</a>
         <a class="collapse-item" href="{{route('manageTeaching')}}">Manage Teaching</a>
         <a class="collapse-item" href="{{route('manageGroupTeaching')}}">Manage Group Teaching</a>
       </div>
     </div>
   </li>
   <hr class="sidebar-divider">
   <div class="sidebar-heading">
     Teachers
   </div>
   <li class="nav-item">
     <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseBootstrapassests" aria-expanded="true" aria-controls="collapseBootstrapassests">
       <i class="fas fa-chalkboard-teacher"></i>
       <span>Manage Teachers</span>
     </a>
     <div id="collapseBootstrapassests" class="collapse" aria-labelledby="headingBootstrap" data-parent="#accordionSidebar">
       <div class="bg-white py-2 collapse-inner rounded">
         <h6 class="collapse-header">Manage Class Teachers</h6>
         <a class="collapse-item" href="{{ route('manageTeacher')}}">Manage Teachers</a>
       </div>
     </div>
   </li>
   <hr class="sidebar-divider">
   <div class="sidebar-heading">
     Students
   </div>

   <li class="nav-item">
     <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseBootstrap2" aria-expanded="true" aria-controls="collapseBootstrap2">
       <i class="fas fa-user-graduate"></i>
       <span>Manage Students</span>
     </a>
     <div id="collapseBootstrap2" class="collapse" aria-labelledby="headingBootstrap" data-parent="#accordionSidebar">
       <div class="bg-white py-2 collapse-inner rounded">
         <h6 class="collapse-header">Manage Students</h6>
         <a class="collapse-item" href="createStudents.php">Create Students</a>
         <a class="collapse-item" href="viewAttendance.php">View Class Attendance</a>
       </div>
     </div>
   </li>

   <hr class="sidebar-divider">
   <div class="sidebar-heading">
     Users
   </div>

   <li class="nav-item">
     <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseBootstrapcon" aria-expanded="true" aria-controls="collapseBootstrapcon">
       <i class="fa fa-calendar-alt"></i>
       <span>Manage Users</span>
     </a>
     <div id="collapseBootstrapcon" class="collapse" aria-labelledby="headingBootstrap" data-parent="#accordionSidebar">
       <div class="bg-white py-2 collapse-inner rounded">
         <h6 class="collapse-header">MANAGE USERS</h6>
         <a class="collapse-item" href="createUsers.php">Create User</a>
       </div>
     </div>
   </li>
 </ul>