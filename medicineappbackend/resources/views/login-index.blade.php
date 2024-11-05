<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">
  <link href="{{asset('img/logo/icon.png')}}" rel="icon">
  <title>NTIC - Login</title>
  <link href="{{asset('vendor/fontawesome-free/css/all.min.css')}}" rel="stylesheet" type="text/css">
  <link href="{{asset('vendor/bootstrap/css/bootstrap.min.css')}}" rel="stylesheet" type="text/css">
  <link href="{{asset('css/ruang-admin.min.css')}}" rel="stylesheet">
</head>

<body>
  <div class="bg">
    <!-- Login Content -->
    <div class="container-login">
      <div class="row justify-content-center">
        <div class="col-xl-6 col-lg-12 col-md-9">
          <div class="card shadow-sm my-5">
            <div class="card-body p-0">
              <div class="row">
                <div class="col-lg-12">
                  <div class="login-form">
                    <div class="text-center">
                      <img src="{{asset('images/logo.png')}}" style="width:120px;height:100px">
                      <br><br>
                      <h1 class="h4 text-gray-900 mb-4">Login</h1>
                    </div>
                    @if ($message != null)
                    <div class="alert alert-danger" role="alert">
                      {{ $message }}
                    </div>
                    @endif
                    @if (session('success'))
                    <div class="alert alert-success text-center" role="alert">
                      {{ session('success') }}
                    </div>
                    @endif
                    <form class="user" method="Post" action="{{route('log')}}">
                      @csrf
                      
                      <div class="form-group">
                        <input type="email" class="form-control" required name="email" id="exampleInputEmail" value="{{old('email')}}" placeholder="Enter Email Address">
                        @if ($errors->has('email'))
                        <span class="text-danger">{{ $errors->first('email') }}</span>
                        @endif
                      </div>
                      <div class="form-group">
                        <input type="password" name="password" required class="form-control" value="{{old('password')}}" id="exampleInputPassword" placeholder="Enter Password">
                      </div>
                      @if ($errors->has('password'))
                      <span class="text-danger">{{ $errors->first('password') }}</span>
                      @endif
                      <div class="form-group">
                        <div class="custom-control custom-checkbox small" style="line-height: 1.5rem;">
                          <input name="remember-me" type="checkbox" class="custom-control-input" id="customCheck">
                          <label class="custom-control-label" for="customCheck">Remember
                            Me</label>
                        </div>
                      </div>
                      <div class="form-group">
                        <input type='submit' name="login" value='Login' class="btn btn-primary btn-block">
                      </div>
                      <!-- <hr>
                        <a href="index.html" class="btn btn-google btn-block">
                          <i class="fab fa-google fa-fw"></i> Login with Google
                        </a>
                        <a href="index.html" class="btn btn-facebook btn-block">
                          <i class="fab fa-facebook-f fa-fw"></i> Login with Facebook
                        </a> -->
                    </form>
                    <hr>
                    <div class="text-center">
                      <a class="font-weight-bold small">Forgot Password !</a>
                    </div>
                    <!-- <div class="text-center">
                      </div> -->
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div>
      <svg class="waves" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 24 150 28" preserveAspectRatio="none" shape-rendering="auto">
        <defs>
          <path id="gentle-wave" d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z" />
        </defs>
        <g class="parallax">
          <use xlink:href="#gentle-wave" x="48" y="0" fill="rgba(255,255,255,0.7" />
          <use xlink:href="#gentle-wave" x="48" y="3" fill="rgba(255,255,255,0.5)" />
          <use xlink:href="#gentle-wave" x="48" y="5" fill="rgba(255,255,255,0.3)" />
          <use xlink:href="#gentle-wave" x="48" y="7" fill="#fff" />
        </g>
      </svg>
    </div>
  </div>
  <!-- this page's style -->
  <style>
    @import url(//fonts.googleapis.com/css?family=Lato:300:400);

    .bg {
      position: relative;
      background: linear-gradient(60deg, rgba(84, 58, 183, 1) 0%, rgba(0, 172, 193, 1) 100%);
    }

    .waves {
      position: relative;
      width: 100%;
      height: 15vh;
      margin-bottom: -7px;
      /*Fix for safari gap*/
      min-height: 100px;
      max-height: 150px;
    }

    /* Animation */

    .parallax>use {
      animation: move-forever 25s cubic-bezier(.55, .5, .45, .5) infinite;
    }

    .parallax>use:nth-child(1) {
      animation-delay: -2s;
      animation-duration: 7s;
    }

    .parallax>use:nth-child(2) {
      animation-delay: -3s;
      animation-duration: 10s;
    }

    .parallax>use:nth-child(3) {
      animation-delay: -4s;
      animation-duration: 13s;
    }

    .parallax>use:nth-child(4) {
      animation-delay: -5s;
      animation-duration: 20s;
    }

    @keyframes move-forever {
      0% {
        transform: translate3d(-90px, 0, 0);
      }

      100% {
        transform: translate3d(85px, 0, 0);
      }
    }

    /*Shrinking for mobile*/
    @media (max-width: 768px) {
      .waves {
        height: 40px;
        min-height: 40px;
      }

      .content {
        height: 30vh;
      }

      h1 {
        font-size: 24px;
      }
    }
  </style>
  <!-- Login Content -->
  <script src="{{asset('vendor/jquery/jquery.min.js')}}"></script>
  <script src="{{asset('vendor/bootstrap/js/bootstrap.bundle.min.js')}}"></script>
  <script src="{{asset('vendor/jquery-easing/jquery.easing.min.js')}}"></script>
  <script src="{{asset('js/ruang-admin.min.js')}}"></script>
</body>

</html>