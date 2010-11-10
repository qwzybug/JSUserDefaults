# JSUserDefaults

Real simple drop-in replacement for UIWebView. Just change the class membership of the web view in your nib (or create it programmatically, that oughta work too) and it'll let you access NSUserDefaults through the JSUserDefaults object. Like this:

    [[NSUserDefaults standardUserDefaults] setObject:@"Bar"
                                              forKey:@"Foo"];

(...some time later...)

    <script type="text/javascript">
      document.write(JSUserDefaults.objectForKey("Foo"));
    </script>

You can also set objects. Any plist object should work fine—arrays, dictionaries, strings, numbers. Other things might be dicey.

See the Demo project for an example.
