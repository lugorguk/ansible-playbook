# Hosted Groups Data

This directory contains several subdirectories and files. Please ignore as
best you can the naming convention right now. They are a convenience ONLY.

Each file will contain a heading, like this:

```yaml
---
lugs_a:
```

or this:

```yaml
---
gone_lugs_z:
```

This heading indicates whether the content of this file should be treated as
still valid (`lugs_*`) or gone (`gone_lugs_*`). A gone service is one where
some services (such as DNS, Web Hosting or Mailing Lists) may exist still, but
are no longer required. Notes should be held on when these were last noticed
as being unnecessary. At some point a "purge" should be performed to remove
the old content... but not today :grin:

Under each of those headings will be a collection of "dictionaries" -
effectively a database record for the groups which begin with that letter,
for example:

```yaml
lugs_e:
  Example_Group:
    notes: Example Notes
    established_date: "2002-12-01"
    last_update: "2016-09-01"
    last_checked: "2020-12-01"
    status: Active

    title: An Example LUG
    categories: Other
    permalink: lugs/Other/Example/
    location:
      latitude: 0.00
      longitude: -0.00

    website: https://www.example.org
    mailing_list: https://mailman.example.org/mailman/listinfo/example/
    contact_address: "{{ protected_email_addresses.example_lug_lugmaster }}"
    contact: John Smith

    dns_name: example
    mail_hosting: "{{ default_mx }}"
    web_hosting: web-01
```

This contains a large group of data, not all of which will be present in
other entries.

The entry is split into several blocks, the first being the "records" fields -
notes, established date, records updated date and last status check date, and
the status of the group.

Next block is the Lugs List section. `title` is self evident, and is used in
TXT records and on the lugs list itself. The `category` defines which area of
the lugs list it appears in with the options being:

* East-Midlands
* East
* London
* North-East
* North-West
* Northern-Ireland
* Other
* Scotland
* South-East
* South-West
* Wales
* West-Midlands
* Yorkshire-and-Humber

Also in this section is the `permalink` - the path under the lug.org.uk
website where this record should be stored (in the format:
`lugs/__CATEGORY__/__NAME__/`) and the location, stored as latitude and
longitude. In a push, use Google Maps to get this location, where the URL will
be in the format: `https://www.google.com/maps/@__LATITUDE__,__LONGITUDE__,__ZOOM__z`

The next section is the lug interaction points. The `website`, `mailing_list`
and `contact` details. At the time of writing, the email address in this
block is the public address of the "lugmaster" or contact form to reach them.
It may also be encrypted using ansible-vault, and stored in [another
file](../protected_email_addresses.yml).

After that, we get the hosting details. These populate both the DNS entries,
if relevant, the respective web server, if relevant, and the mail forwarder,
if relevant.

The first part of this is the `dns_name`. This is the starting point for all
these records, and will form the beginning of the line
`example IN A 192.0.2.1` which tells the DNS to create that A record.

If a service has multiple records it wants to create here, this will be
specified later as `extra_dns_records`.

All lug.org.uk hosts should be using the "default" mail servers for, unless
they are hosting their own. To use the default servers, enter
`mail_hosting: "{{ default_mx }}` and Ansible will replace `{{ default_mx }}`
with a list containing the `mail-in-01.lug.org.uk` and
`mail-in-01.glug.org.uk` values.

If the service has more complex requirements, put them in here as an ordered
list. The increments will go up in steps of 10, for example:

```yaml
mail_hosting:
- server-01.example.org.
- server-01.example.net.
- some-backup-relay.emergency.example.com.
```

If using the default MX records, this will be, like this:
```yaml
mail_hosting:
- mail-in-01.lug.org.uk.
- mail-in-01.glug.org.uk.
```

Next, web hosting. These fall into three "camps". A redirect, hosted content
or an inactive record. So, these are built as follows:

A redirect:

```yaml
web_hosting:
  via: web-01
  to: https://example.org
```

Hosted content:

```yaml
web_hosting:
  host: snm
  type: static # may also be dokuwiki or abusemod
```

Inactive:

```yaml
web_hosting:
  host: web-01
  type: inactive
```

You may also find the "legacy" static entry, which looks like this:

```yaml
web_hosting: snm
```

If a group has additional DNS requirements, these should be recorded in an
`extra_dns_records` field, like this:

```yaml
extra_dns_records:
- type: NS
  record: ns.example.com
- type: NS
  record: ns.example.org
```

This creates two NS records for the "target" of the `dns_name`, pointing to
`ns.example.com` and `ns.example.org`.

Or like this:

```yaml
extra_dns_records:
- type: A
  record: 192.0.2.1
- type: CNAME
  target: test.example
```

This creates two records, an A record for the "target" of the `dns_name`,
pointing to an IPv4 address, and a CNAME for a separate DNS prefix,
`test.example`, with a record pointing to the `dns_name`.

Any time either the `record` or `target` item is omitted from an
`extra_dns_records` entry, the value of `dns_name` is added instead.