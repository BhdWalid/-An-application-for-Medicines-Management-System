<!DOCTYPE html>
<html>
@include("admin.includes.head")

<body id="page-top">
<div class="modal fade" id="confirmModal" style="display: none; z-index: 1050;">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body" id="confirmMessage">
        </div>
        <div id='deatails'>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" id="confirmCancel">Close</button>
          <button type="button" class="btn btn-danger" id="confirmOk">Delete</button>
        </div>
      </div>
    </div>
  </div>


  <div id="wrapper">
    <!--wrapper-->
    <!-- Sidebar -->
    @include("admin.Includes.sidebar")
    <!-- Sidebar -->
    <div id="content-wrapper" class="d-flex flex-column">
      <!--content-wrapper-->
      <div id="content">
        <!--content-->
        <!-- TopBar -->
        @include("admin.Includes.topbar")
        <!-- Topbar -->