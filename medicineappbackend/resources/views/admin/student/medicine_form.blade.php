<!-- Form Basic -->
<div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
  <h6 class="m-0 font-weight-bold text-primary">Add Medicine</h6>
  Add a new medicine
</div>
<div class="card-body">
  <form method="POST" action="{{ route('create_medicine') }}" enctype="multipart/form-data">
    @csrf
    <div class="form-group row mb-3">
      <div class="col-xl-6">
        <label class="form-control-label">Medicine Name<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('name_medicine') is-invalid @enderror" required name="name_medicine" value="{{ old('name_medicine') }}">
        @error('name_medicine')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Bar Code<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('bar_code') is-invalid @enderror" required name="bar_code" value="{{ old('bar_code') }}">
        @error('bar_code')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Price<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('price') is-invalid @enderror" required name="price" value="{{ old('price') }}">
        @error('price')
          <span class="invalid-feedback" role="alert">{{ $message }}</span>
        @enderror
      </div>
      <div class="col-xl-6">
        <label class="form-control-label">Image<span class="text-danger ml-2">*</span></label>
        <input type="text" class="form-control @error('image') is-invalid @enderror"  name="image" value="{{ old('image') }}">
        @error('image')
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
