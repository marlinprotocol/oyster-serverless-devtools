addEventListener('fetch', event => {
    event.respondWith(handle(event.request));
});

async function handle(request) {
    try {
        const data = await request.json();
        console.log(data);

        let num = data.num;
        let factors = [];
        let divisor = 2;
        if(typeof num != 'number') {
            return new Response(`Please provide a valid integer as input in the format {'num':10}`);
        }

        while (num > 2) {
            if (num % divisor === 0) {
                factors.push(divisor);
                num /= divisor;
            } else {
                divisor++;
            }
        }

        if(factors.length == 0) {
            return new Response('No prime factor for the provided number');
        }

        return new Response(factors);
    } catch(err) {
        console.log(err);
        return new Response('Please provide a valid JSON input');
    }
}

