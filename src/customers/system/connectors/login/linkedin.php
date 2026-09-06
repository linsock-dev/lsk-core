<script type="text/javascript" src="//platform.linkedin.com/in.js">
    api_key: YOUR_API_KEY_HERE
    authorize: true
    onLoad: onLinkedInLoad
</script>

<script type="text/javascript">
    
    // Setup an event listener to make an API call once auth is complete
    function onLinkedInLoad() {
        IN.Event.on(IN, "auth", LinkedinGetProfileData);
    }

    // Handle the successful return from the API call
    function LinkedinOnSuccess(data) {
        console.log(data);
    }

    // Handle an error response from the API call
    function LinkedinOnError(error) {
        console.log(error);
    }

    // Use the API call wrapper to request the member's basic profile data
    function LinkedinGetProfileData() {
        IN.API.Raw("/people/~").result(LinkedinOnSuccess).error(LinkedinOnError);
    }

</script>