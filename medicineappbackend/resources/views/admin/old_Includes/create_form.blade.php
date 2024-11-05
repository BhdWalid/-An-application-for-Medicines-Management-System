<!-- Form Basic -->
<div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
  <h6 class="m-0 font-weight-bold text-primary">Create Teachers</h6>
  create new teacher
</div>
<div class="card-body">
  <form>
    <div class="form-group row mb-3">

      <div class="col-xl-6">
        <label class="form-control-label">ID<span class="text-danger ml-2">*</span></label>
        <input type="number" class="form-control" required name="teacher_id" >
        <span id="teacher_id_error" class="invalid-feedback"></span>
      </div>
     
      <div class="col-xl-6">
        <label class="form-control-label">Firstname<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="teacher_first_name" >
        <span id="teacher_first_name_error" class="invalid-feedback"></span>
       
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Lastname<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="teacher_last_name" >
        <span id="teacher_last_name_error" class="invalid-feedback"></span>

      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Grade<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control" required name="teacher_grade" >
        <span id="teacher_grade_error" class="invalid-feedback"></span>

      </div>
    </div>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <label class="form-control-label">Email Address<span class="text-danger ml-2">*</span></label>
        <input type="email" class="form-control" required name="teacher_email" >
        <span id="teacher_email_error" class="invalid-feedback"></span>

      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Password<span class="text-danger ml-2">*</span></label>
        <input type="password" class="form-control" required name="teacher_password" >
        <span id="teacher_password_error" class="invalid-feedback"></span>

      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Phone No<span class="text-danger ml-2">*</span></label>
        <input type="number" class="form-control" name="teacher_phone" >
        <span id="teacher_phone_error" class="invalid-feedback"></span>
      
      </div>
    </div>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
       
        <button type="button" id='submit' name="save" value="save" class="btn btn-primary">Save</button>
      </div>
    </div>

  </form>
</div>