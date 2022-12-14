package com.slv.wall.wallpaper;

import android.annotation.SuppressLint;
import android.app.DownloadManager;
import android.app.WallpaperManager;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.util.Pair;
import android.widget.Toast;


import androidx.annotation.NonNull;

import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "flutter.prism.set_wallpaper";
    public static MethodChannel.Result res;
    private Target target = new Target() {
        @Override
        public void onBitmapLoaded(Bitmap resource, Picasso.LoadedFrom from) {
            android.util.Log.i("Arguments ", "configureFlutterEngine: " + "Image Downloaded");
            SetWallPaperTask setWallPaperTask = new SetWallPaperTask(getActivity());
            setWallPaperTask.execute(new Pair(resource, "1"));
        }

        @Override
        public void onBitmapFailed(Exception e, Drawable errorDrawable) {
        }

        @Override
        public void onPrepareLoad(Drawable placeHolderDrawable) {
        }
    };
    private Target target1 = new Target() {
        @Override
        public void onBitmapLoaded(Bitmap resource, Picasso.LoadedFrom from) {
            android.util.Log.i("Arguments ", "configureFlutterEngine: " + "Image Downloaded");
            SetWallPaperTask setWallPaperTask = new SetWallPaperTask(getActivity());
            setWallPaperTask.execute(new Pair(resource, "2"));
        }

        @Override
        public void onBitmapFailed(Exception e, Drawable errorDrawable) {
        }

        @Override
        public void onPrepareLoad(Drawable placeHolderDrawable) {
        }
    };
    private Target target2 = new Target() {
        @Override
        public void onBitmapLoaded(Bitmap resource, Picasso.LoadedFrom from) {
            android.util.Log.i("Arguments ", "configureFlutterEngine: " + "Image Downloaded");
            SetWallPaperTask setWallPaperTask = new SetWallPaperTask(getActivity());
            setWallPaperTask.execute(new Pair(resource, "3"));
        }

        @Override
        public void onBitmapFailed(Exception e, Drawable errorDrawable) {
        }

        @Override
        public void onPrepareLoad(Drawable placeHolderDrawable) {
        }
    };
    private Target target3 = new Target() {
        @Override
        public void onBitmapLoaded(Bitmap resource, Picasso.LoadedFrom from) {
            android.util.Log.i("Arguments ", "configureFlutterEngine: " + "Image Downloaded");
            SetWallPaperTask setWallPaperTask = new SetWallPaperTask(getActivity());
            setWallPaperTask.execute(new Pair(resource, "4"));
        }

        @Override
        public void onBitmapFailed(Exception e, Drawable errorDrawable) {
        }

        @Override
        public void onPrepareLoad(Drawable placeHolderDrawable) {
        }
    };
    Target saveImageTarget = new Target() {
        @Override
        public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
            try {
                saveImageToPictures(bitmap, "default_" + System.currentTimeMillis());
            } catch (IOException e) {
                e.printStackTrace();
                res.success(false);
            }
        }

        @Override
        public void onBitmapFailed(Exception e, Drawable errorDrawable) {
            res.success(false);
            e.printStackTrace();
        }

        @Override
        public void onPrepareLoad(Drawable placeHolderDrawable) {
        }
    };

    Target saveSetupTarget = new Target() {
        @Override
        public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
            try {
                saveImageToPictures(bitmap, "Prism Setups/default_" + System.currentTimeMillis());
            } catch (IOException e) {
                e.printStackTrace();
                res.success(false);
            }
        }

        @Override
        public void onBitmapFailed(Exception e, Drawable errorDrawable) {
            res.success(false);
            e.printStackTrace();
        }

        @Override
        public void onPrepareLoad(Drawable placeHolderDrawable) {
        }
    };
    private void downloadImageNew(String filename, String downloadUrlOfImage){
        try{
            DownloadManager dm = (DownloadManager) getSystemService(Context.DOWNLOAD_SERVICE);
            Uri downloadUri = Uri.parse(downloadUrlOfImage);
            DownloadManager.Request request = new DownloadManager.Request(downloadUri);
            request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI | DownloadManager.Request.NETWORK_MOBILE)
                    .setAllowedOverRoaming(false)
                    .setTitle(filename)
                    .setDescription("Downloading wallpaper")
                    .setMimeType("image/jpeg") // Your file type. You can use this code to download other file types also.
                    .setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
                    .setDestinationInExternalPublicDir(Environment.DIRECTORY_PICTURES,File.separator + "Prism"+ File.separator + filename + ".jpg");
            dm.enqueue(request);
            Toast.makeText(this, "Image download started.", Toast.LENGTH_SHORT).show();
        }catch (Exception e){
            Toast.makeText(this, "Image download failed." + e.getMessage().toString(), Toast.LENGTH_SHORT).show();
        }
    }
    private void saveImageToPictures(Bitmap bitmap, @NonNull String name) throws IOException {
        OutputStream fos;
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                ContentResolver resolver = getContentResolver();
                ContentValues contentValues = new ContentValues();
                contentValues.put(MediaStore.MediaColumns.DISPLAY_NAME, name + ".jpg");
                contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "image/jpg");
                contentValues.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES + File.separator + "Prism");
                Uri imageUri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);
                fos = resolver.openOutputStream(Objects.requireNonNull(imageUri));
            } else {
                String imagesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES + File.separator + "Prism").toString();
                File image = new File(imagesDir, name + ".jpg");
                fos = new FileOutputStream(image);
            }
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            Objects.requireNonNull(fos).close();
        } catch (Exception e) {
            e.printStackTrace();
            res.success(false);
        }
        res.success(true);
    }
private  void getImageDir(){
    ArrayList<String>listPath=new ArrayList<>();
        String dir=Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES+File.separator+ "Prism").toString();
        File   path=new File(dir);
    if(path.exists())
    {

        boolean success=deleteDir(path);
        res.success(success);
    }

}

    public static boolean deleteDir(File dir) {
        if (dir.isDirectory()) {
            String[] children = dir.list();
            for (int i=0; i<children.length; i++) {
                boolean success = deleteDir(new File(dir, children[i]));
                if (!success) {
                    return false;
                }
            }
        }

        // The directory is now empty so delete it
        return dir.delete();
    }
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(),CHANNEL).setMethodCallHandler((call,result)->{
            res = result;
            if (call.method.equals("set_wallpaper")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load(url).into(target);

            } else if (call.method.equals("set_wallpaper_file")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load("file://" + url).into(target);

            } else if (call.method.equals("set_lock_wallpaper")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load(url).into(target1);

            } else if (call.method.equals("set_home_wallpaper")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load(url).into(target2);

            } else if (call.method.equals("set_both_wallpaper")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load(url).into(target3);

            } else if (call.method.equals("set_lock_wallpaper_file")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load("file://" + url).into(target1);

            } else if (call.method.equals("set_home_wallpaper_file")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load("file://" + url).into(target2);

            } else if (call.method.equals("set_both_wallpaper_file")) {
                String url = call.argument("url"); // .argument returns the correct type
                android.util.Log.i("Arguments ", "configureFlutterEngine: " + url);
                Picasso.get().load("file://" + url).into(target3);

            } else if (call.method.equals("save_image")) {
                String link = call.argument("link");
                Picasso.get().load(link).into(saveImageTarget);
            } else if (call.method.equals("save_image_file")) {
                String link = call.argument("link");
                Picasso.get().load("file://" + link).into(saveImageTarget);
            } else if (call.method.equals("save_setup")) {
                String link = call.argument("link");
                Picasso.get().load(link).into(saveSetupTarget);
            } else if (call.method.equals("download_image_dm")) {
                String link = call.argument("link");
                String filename = call.argument("filename");
                downloadImageNew(filename,link);
            } else if (call.method.equals("deleteFile")) {
//                String link = call.argument("link");
//                String filename = call.argument("filename");
//                downloadImageNew(filename,link);
                getImageDir();
            }
        });
    }
}
class SetWallPaperTask extends AsyncTask<Pair<Bitmap, String>, Boolean, Boolean> {

    private final Context mContext;

    public SetWallPaperTask(final Context context) {
        mContext = context;
    }

    @Override
    protected final Boolean doInBackground(Pair<Bitmap, String>... pairs) {
        switch (pairs[0].second) {
            case "1": {
                WallpaperManager wallpaperManager = WallpaperManager.getInstance(mContext);
                try {
                    Uri tempUri = getImageUri(mContext, pairs[0].first);
                    Log.i("Arguments ", "configureFlutterEngine: " + "Saved image to storage");
                    File finalFile = new File(getRealPathFromURI(tempUri));
                    Uri contentURI = getImageContentUri(mContext, finalFile.getAbsolutePath());
                    Log.i("Arguments ", "configureFlutterEngine: " + "Opening crop intent");
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                        mContext.startActivity(wallpaperManager.getCropAndSetWallpaperIntent(contentURI));
                    }
                    // wallpaperManager.setBitmap(pairs[0].first);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    return false;
                }
            }
            case "2": {
                WallpaperManager wallpaperManager = WallpaperManager.getInstance(mContext);
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        wallpaperManager.setBitmap(pairs[0].first, null, true, WallpaperManager.FLAG_LOCK);
                    }
                } catch (IOException ex) {
                    ex.printStackTrace();
                    return false;
                }
                break;
            }
            case "3": {
                WallpaperManager wallpaperManager = WallpaperManager.getInstance(mContext);
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        wallpaperManager.setBitmap(pairs[0].first, null, true, WallpaperManager.FLAG_SYSTEM);
                    }
                } catch (IOException ex) {
                    ex.printStackTrace();
                    return false;
                }
                break;
            }
            case "4": {
                WallpaperManager wallpaperManager = WallpaperManager.getInstance(mContext);
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        wallpaperManager.setBitmap(pairs[0].first, null, true,
                                WallpaperManager.FLAG_LOCK | WallpaperManager.FLAG_SYSTEM);
                    }
                } catch (IOException ex) {
                    ex.printStackTrace();
                    return false;
                }
                break;
            }

        }
        return true;
    }

    @Override
    protected void onCancelled() {
        super.onCancelled();
    }

    @Override
    protected void onPostExecute(Boolean aBoolean) {
        myMethod(aBoolean);
    }

    private void myMethod(Boolean result) {
        MainActivity.res.success(result);
    }

    public static Uri getImageContentUri(Context context, String absPath) {

        Cursor cursor = context.getContentResolver().query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                new String[]{MediaStore.Images.Media._ID}, MediaStore.Images.Media.DATA + "=? ",
                new String[]{absPath}, null);

        if (cursor != null && cursor.moveToFirst()) {
            @SuppressLint("Range") int id = cursor.getInt(cursor.getColumnIndex(MediaStore.MediaColumns._ID));
            return Uri.withAppendedPath(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, Integer.toString(id));

        } else if (!absPath.isEmpty()) {
            ContentValues values = new ContentValues();
            values.put(MediaStore.Images.Media.DATA, absPath);
            return context.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        } else {
            return null;
        }
    }

    public Uri getImageUri(Context inContext, Bitmap inImage) {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
        fixMediaDir();
        String path = MediaStore.Images.Media.insertImage(inContext.getContentResolver(), inImage, "Title", null);
        return Uri.parse(path);
    }

    public String getRealPathFromURI(Uri uri) {
        Cursor cursor = mContext.getContentResolver().query(uri, null, null, null, null);
        cursor.moveToFirst();
        int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
        return cursor.getString(idx);
    }

    void fixMediaDir() {
        File sdcard = Environment.getExternalStorageDirectory();
        if (sdcard != null) {
            File mediaDir = new File(sdcard, "DCIM/Camera");
            if (!mediaDir.exists()) {
                mediaDir.mkdirs();
            }
        }

        if (sdcard != null) {
            File mediaDir = new File(sdcard, "Pictures");
            if (!mediaDir.exists()) {
                mediaDir.mkdirs();
            }
        }
    }
}