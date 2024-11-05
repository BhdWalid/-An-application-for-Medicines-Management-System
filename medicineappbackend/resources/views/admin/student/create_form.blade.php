<!-- Form Basic -->
<div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
  <h6 class="m-0 font-weight-bold text-primary">Create Accounts</h6>
  create new account
</div>
<div class="card-body">
  <form method="POST" action="{{ route('CreateAccount') }}">
    @csrf
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <label class="form-control-label">Firstname<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('first_name') is-invalid @enderror" required name="first_name" value="{{ old('first_name') }}">
        @error('first_name')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Lastname<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('last_name') is-invalid @enderror" required name="last_name" value="{{ old('last_name') }}">
        @error('last_name')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Email Address<span class="text-danger ml-2">*</span></label>
        <input type="email" class="form-control @error('email') is-invalid @enderror" required name="email" value="{{ old('email') }}">
        @error('email')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Phone Number<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('phone_number') is-invalid @enderror" required name="phone_number" value="{{ old('phone_number') }}">
        @error('phone_number')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Password<span class="text-danger ml-2">*</span></label>
        <input type="password" class="form-control @error('password') is-invalid @enderror" required name="password">
        @error('password')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Type User<span class="text-danger ml-2">*</span></label>
        <select required name="type_user" id="type_user" class="form-control @error('type_user') is-invalid @enderror">
          <option value="">--Select Type User--</option>
          <option value="doctor" {{ old('type_user') == 'doctor' ? 'selected' : '' }}>Doctor</option>
          <option value="patient" {{ old('type_user') == 'patient' ? 'selected' : '' }}>Patient</option>
          <option value="pharmacist" {{ old('type_user') == 'pharmacist' ? 'selected' : '' }}>Pharmacist</option>
        </select>
        @error('type_user')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Address<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('address') is-invalid @enderror" required name="address" value="{{ old('address') }}">
        @error('address')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6" id="specialty_field" style="display: none;">
        <label class="form-control-label">Specialty</label>
        <input type="text" class="form-control @error('specialty') is-invalid @enderror" name="specialty" value="{{ old('specialty') }}">
        @error('specialty')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6" id="birthday_field" style="display: none;">
        <label class="form-control-label">Birthday</label>
        <input type="date" class="form-control @error('birthday') is-invalid @enderror" name="birthday" value="{{ old('birthday') }}">
      @error('birthday')
        <span class="invalid-feedback" role="alert">{{ $message }}</span>
      @enderror
      </div>
      <div class="col-xl-6" id="doctor_id_field" style="display: none;">
        <label class="form-control-label">Doctor ID</label>
        <input type="text" class="form-control @error('doctor_id_doctor') is-invalid @enderror" name="doctor_id_doctor" value="{{ old('doctor_id_doctor') }}">
        @error('doctor_id_doctor')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6" id="reason_field" style="display: none;">
        <label class="form-control-label">Reason</label>
        <input type="text" class="form-control @error('reason') is-invalid @enderror" name="reason" value="{{ old('reason') }}">
        @error('reason')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6" id="name_field" style="display: none;">
        <label class="form-control-label">Name</label>
        <input type="text" class="form-control @error('name') is-invalid @enderror" name="name" value="{{ old('name') }}">
        @error('name')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6" id="location_field" style="display: none;">
        <label class="form-control-label">Location</label>
        <input type="text" class="form-control @error('location') is-invalid @enderror" name="location" value="{{ old('location') }}">
        @error('location')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
    </div>
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <button type="submit" id="submit" name="save" value="save" class="btn btn-primary">Save</button>
      </div>
    </div>
  </form>
</div>

<script>
  document.getElementById('type_user').addEventListener('change', function() {
    var selectedValue = this.value;
    var specialtyField = document.getElementById('specialty_field');
    var birthdayField = document.getElementById('birthday_field');
    var doctorIdField = document.getElementById('doctor_id_field');
    var reasonField = document.getElementById('reason_field');
    var nameField = document.getElementById('name_field');
    var locationField = document.getElementById('location_field');

    // Hide all fields
    specialtyField.style.display = 'none';
    birthdayField.style.display = 'none';
    doctorIdField.style.display = 'none';
    reasonField.style.display = 'none';
    nameField.style.display = 'none';
    locationField.style.display = 'none';

    if (selectedValue === 'doctor') {
      specialtyField.style.display = 'block';
    } else if (selectedValue === 'patient') {
      birthdayField.style.display = 'block';
      doctorIdField.style.display = 'block';
      reasonField.style.display = 'block';
    } else if (selectedValue === 'pharmacist') {
      nameField.style.display = 'block';
      locationField.style.display = 'block';
    }
  });
</script>
